PROGRAM _INIT
	getCrosslinkInfo:=1;
END_PROGRAM

PROGRAM _CYCLIC
	
	Axis1DIs := 0;
	Axis1DIs := Axis1DIs + SHL(BOOL_TO_UDINT(IO.NotTop), 0);
	Axis1DIs := Axis1DIs + SHL(BOOL_TO_UDINT(IO.NotBottom), 1);
	

	IF getCrosslinkInfo THEN
		
		PlActionGetDPInfo.DeviceName := ADR('IF3');
		PlActionGetDPInfo.ChannelName := ADR('Broadcast_1'); 
		plActionStatus := plAction(0,plACTION_GET_DP_INFO,ADR(PlActionGetDPInfo),SIZEOF(PlActionGetDPInfo));
		
		IF plActionStatus = 0 THEN
			
			MC_BR_InitReceiveNetworkData_0.Axis:=ADR(gAxis03);
			MC_BR_InitReceiveNetworkData_0.NodeNumber:= PlActionGetDPInfo.SrcNode;
			MC_BR_InitReceiveNetworkData_0.BitOffset:= (PlActionGetDPInfo.OffsetAbs / 32) *32; (* determine bit offset in multiples of 32 bits *)
			MC_BR_InitReceiveNetworkData_0.DataType:=ncPAR_TYP_UDINT;
			MC_BR_InitReceiveNetworkData_0.InterpolationMode:=mcIPL_OFF;
			MC_BR_InitReceiveNetworkData_0.ReceiveChannel:=1;
			MC_BR_InitReceiveNetworkData_0.Execute:=TRUE;
			MC_BR_InitReceiveNetworkData_0();
			
			IF MC_BR_InitReceiveNetworkData_0.Done THEN
				getCrosslinkInfo := FALSE;
			END_IF
		END_IF
	END_IF

END_PROGRAM


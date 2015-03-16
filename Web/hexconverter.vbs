'	Hex to decimal converter!
Function HexToDec(strHex)
  dim lngResult
  dim intIndex
  dim strDigit
  dim intDigit
  dim intValue
  lngResult = 0
  for intIndex = len(strHex) to 1 step -1
    strDigit = mid(strHex, intIndex, 1)
    intDigit = instr("0123456789ABCDEF", ucase(strDigit))-1
    if intDigit >= 0 then
      intValue = intDigit * (16 ^ (len(strHex)-intIndex))
      lngResult = lngResult + intValue
    else
      lngResult = 0
      intIndex = 0 ' stop the loop
    end if
  next
  HexToDec = lngResult
End Function
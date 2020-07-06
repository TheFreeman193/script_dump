local tbl = {
	FirstMember = { Name = "John Smith", Age  = 25 },
	SecondMember = { Name = "Jane Doe", Age = 42 },
	ThirdMember = { Name = "Joe Bloggs", Age = 39 }
}
print( "===== Before =====" )
PrintTable( tbl )
local tbl2 = table.ClearKeys( tbl, true )
print( "===== After =====" )
PrintTable( tbl2 )
/*
<nowiki>===== Before =====</nowiki>
FirstMember:
		Name	=	John Smith
		Age	=	25
SecondMember:
		Name	=	Jane Doe
		Age	=	42
ThirdMember:
		Name	=	Joe Bloggs
		Age	=	39
<nowiki>===== After =====</nowiki>
1:
		Age	=	25
		Name	=	John Smith
		__key	=	FirstMember
2:
		Age	=	39
		Name	=	Joe Bloggs
		__key	=	ThirdMember
3:
		Age	=	42
		Name	=	Jane Doe
		__key	=	SecondMember
*/

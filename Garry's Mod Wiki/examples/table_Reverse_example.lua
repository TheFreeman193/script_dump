local tbl = { "One", "Two", "Three", four = 4, [5] = "5" }

PrintTable(tbl)
print("")
PrintTable(table.Reverse(tbl))

/*1	=	One
2	=	Two
3	=	Three
four	=	4
5	=	5

1	=	Three
2	=	Two
3	=	One
*/
local tbl = {"One", "Two", [6] = "Six", [42] = "Answer to life, the universe, and everything"}

PrintTable(tbl)
print("\n" .. #tbl)
print(table.maxn(tbl))

<pre>1	=	One
2	=	Two
6	=	Six
42	=	Answer to life, the universe, and everything

2
42
</pre>
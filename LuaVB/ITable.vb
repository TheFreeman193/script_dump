' Lua-style tables in .NET

Imports Microsoft.VisualBasic

Public Class ITable
    Inherits Hashtable

    Private Last As Integer = 0
    Private Start As Integer = 0

    Default Public Shadows Property Item(key As Object) As Object
        Get
            Return MyBase.Item(key)
        End Get
        Set(value)
            If value Is Nothing Or value Is Nothing Then : MyBase.Remove(key)
            Else
                MyBase.Item(key) = value
                If IsNumeric(key) Then
                    key = Convert.ToInt32(key)
                    If Not Me.ContainsKey(key) And key = (Me.Last + 1) Then Me.Last = key
                End If
            End If
        End Set
    End Property



    Public Shadows Sub Add(key As Object, Optional value As Object = Nothing)
        If value Is Nothing Then
            'Console.WriteLine(Me.ContainsKey(me.Last))
            Do While (Me.ContainsKey(Me.Last) Or Me.Last = 0)
                Me.Last += 1
                'Console.WriteLine("Me.Last: " & Me.Last.ToString)
            Loop
            MyBase.Add(Me.Last, key)
        Else
            If IsNumeric(key) Then
                key = Convert.ToInt32(key)
                If Me.ContainsKey(key) Then : Me.Item(key) = value
                Else : Me.Add(key, value)
                End If
            Else
                MyBase.Add(key, value)
            End If

        End If
    End Sub

    Public Sub Insert(index As Int32, value As Object)
        If Not Me.ContainsKey(index) Then
            MyBase.Add(index, value)
        Else
            For i As Integer = Me.Last To index Step -1
                MyBase.Item(i + 1) = MyBase.Item(i)
            Next
            MyBase.Item(index) = value
            Me.Last += 1
        End If
    End Sub

    Dim rmposlist As New ArrayList
    Public Sub RemoveAllInstances(value As Object)
        If Me.ContainsValue(value) Then
            Dim i = 0
            rmposlist.Clear()

            For Each vlu In Me.Values
                If vlu = value Then rmposlist.Add(Me.Keys(i))
                i += 1
            Next
            For i = 0 To rmposlist.Count - 1
                Me.Remove(rmposlist(i))
            Next

        End If
    End Sub

    'Private WithEvents GapTimer As New Timers.Timer With {.Interval = 2, .Enabled = False, .AutoReset = False}
    'Private Sub GapTimeTrigger() Handles GapTimer.Elapsed
    '    RemoveNumericGaps()
    '    Console.WriteLine("Gaps Cleared.")
    'End Sub
    'Private GapPoint As Integer
    Public Shadows Sub Remove(key As Object)
        If Not Me.ContainsKey(key) Then Exit Sub
        MyBase.Remove(key)
        'If IsNumeric(key) Then
        'If key <= Me.Last Then Me.Last = key - 1
        'End If
    End Sub

    Dim curNumMax As Integer
    Public Sub Cleanup()


        RunCleanup()

        UpdateBounds()
    End Sub

    Private Sub RunCleanup(Optional startpos As Integer = 0)
        'MsgBox("Count: " & Me.Count)
 
        UpdateBounds(If(startpos > 0, startpos, Nothing))
        'If Me.Start > 0 Then
        Dim diff = Me.Start - NextFree
        '        Console.WriteLine("Cleaning from " & Me.Start.ToString & " to " & Me.Last & ".")
        For i = Me.Start To Me.Last
            Me.Item(i - diff) = Me.Item(i)
            Me.Item(i) = Nothing
        Next
        'Console.Clear()
        'Console.WriteLine(NumericLength)

        If Me.Last < curNumMax Then
            RunCleanup(Me.Last)
        End If

        'End If


    End Sub

    Private NextFree As Integer = 0
    Private Sub UpdateBounds(Optional startpos = Nothing)
        Dim complete = False, lastnumeric = 0, found = False, st = 0, started = False

        Dim counter = If(startpos, 0) 'NumericLength())
        curNumMax = Me.GetNumericMax
        '        Console.WriteLine("curNumMax: " & curNumMax.ToString)
        'Console.WriteLine("counter start: " & counter.ToString)
        'Console.WriteLine("numeric length: " & NumericLength())
        Do Until complete = True  '======== remove ========
            '            Console.WriteLine(counter & ": ContainsKey=" & Me.ContainsKey(counter) & " started=" & started & " found=" & found)
            If Me.ContainsKey(counter) Then
                If found = False And started = True Then
                    found = True
                    '                    Console.WriteLine("Found = true at " & counter.ToString)
                    st = counter
                ElseIf found = False And started = False And counter = curNumMax Then
                    '                    Console.WriteLine("Stopping Counter at " & counter.ToString & ", No gaps remain.")
                    complete = True
                    st = 1
                    lastnumeric = counter
                End If
                counter += 1
            Else
                If found = True And started = True Then
                    '                   Console.WriteLine("Stopping Counter at " & counter.ToString)
                    lastnumeric = counter - 1
                    complete = True
                ElseIf started = False Then
                    started = True
                    Me.NextFree = counter
                    '                    Console.WriteLine("Started = true at " & counter.ToString)
                    counter += 1
                Else 'found = false
                    counter += 1
                End If
            End If


            'Console.WriteLine("[" & Count.ToString & "]")

            'If Me.ContainsKey(counter) And found = True Then
            '    counter += 1
            'ElseIf found = False Then
            '    counter += 1
            'ElseIf found = True And Not Me.ContainsKey(counter) Then
            '    lastnumeric = counter
            '    complete = True
            'End If
            'If counter Mod 1000 = 0 Then Console.WriteLine(counter.ToString)


            'If counter > (curNumMax + 5) Then
            '    MsgBox("Exceeded range!")
            '    Exit Do
            'End If
        Loop
        Me.Last = lastnumeric
        Me.Start = st
        '        Console.WriteLine("Start = " & st & " / Last = " & lastnumeric)
    End Sub

    Private Sub RemoveNumericGap(start As Integer)
        'Console.WriteLine("Removal Arrived!")
        For i = start + 1 To Me.Last
            MyBase.Item(i - 1) = MyBase.Item(i)
        Next
        MyBase.Remove(Me.Last)
    End Sub


    Public Sub RemoveValue(value As Object)
        If Me.ContainsValue(value) Then
            Dim i = 0
            For Each vlu In Me.Values
                If vlu = value Then Exit For
                i += 1
            Next
            Me.Remove(Me.Keys(i))
        End If
    End Sub

    Public Overrides Function ToString() As String
        Dim output As String = ""
        Dim count = Me.Count
        For i = 0 To count - 1
            Dim k = MyBase.Keys(i), val = MyBase.Values(i)
            output = output & If(i = 0, Me.Count & " Key-Value" & If(count > 1, "s", "") & ":" & vbNewLine & vbNewLine, vbNewLine) & "[" & k.GetType.Name & "] " & k.ToString & ": " & _
                val.ToString & " [" & val.GetType.Name & "]"
        Next i
        'output = output & vbNewLine & vbNewLine & "Last: " & Me.Last.ToString _
        '   & vbNewLine & "Start: " & Me.Start.ToString
        Return output
    End Function

    Public Overrides Sub Clear()
        Me.Last = 0
        MyBase.Clear()
    End Sub

    Public Function GetMax()
        Return Me.Last
    End Function

    Public Function GetNumericMax()
        Dim largest = 0
        For i = 0 To Me.Count - 1
            Dim key = Me.Keys(i)
            If IsNumeric(key) Then If key > largest Then largest = key
        Next
        Return largest
    End Function

    Public Function NumericLength()
        'Console.WriteLine("NL Called!")
        If Me.Count = 0 Then Return 0
        Dim out = 0
        For i = 1 To Me.Count
            If Not Me.ContainsKey(i) Then
                Return (i - 1)
            End If
        Next
        Return Me.Count
    End Function
End Class

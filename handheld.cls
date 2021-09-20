/// Description
Class Handheld.Instruction Extends %Persistent
{

/// Description
Property operation As %String;

/// Description
Property argument As %Integer;

/// Description
ClassMethod Import(dir As %String = "/usr/local/day8.txt") As %Status
{
    // Open my text file and check it exists
    IF ##class(%File).Exists(dir) '=1 {
    write !, "Unable to Open: "_dir
    QUIT}
    ELSE { write "File: "_dir_" is open"
    }

    // instantiate a new class called file
    set file = ##class(%Stream.FileCharacter).%New()
    // create a new variable called sc
    set sc = file.LinkToFile(dir)
    set count=1
    /// loop to go through the day3 txt file 
    WHILE ('file.AtEnd)
    {
        set delim="^"
        set line = file.ReadLine()
        write !, "We are within the iterative loop"
        write *32
        write line,!
        set lim = " "
        set accumulator=0
        set position=0

        
        // Uses $Piece to extract lines parts and assign them to an array called lines
        set lines(count)=$PIECE(line, delim)
        set instructions = ##class(Handheld.Instructions).%New()
        
        set operation(count)=$PIECE(lines(count),lim)
        set instructions.operation=operation(count)
        write "Operation: ",instructions.operation ,!
        set argument(count)=$PIECE(lines(count),lim,*)
        set instructions.argument=argument(count)
        write "Argument: ",instructions.argument ,!
        set sc = instructions.%Save()
        set countdown=$LENGTH(line,delim)
        set count=$INCREMENT(count)   

       
    }
        write !,*32
        write !, "Double checking to see if the lines array is set"
        write !,*32
        
        
        write !, "1st iteration of lines array ", lines(1)
        write !, "2nd iteration of lines array ", lines(2)
        write !, "3rd iteration of lines array ", lines(3)
        write !, "End of loop import process complete"
        write *32

        
        write "Done" ,!
        #;set instructions = ##class(Handheld.Instructions).%New()

        #;set instructions.operation = "line"
        #;set sc = instructions.%Save()
        #;write instructions.operation ,!
}

Storage Default
{
<Data name="InstructionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>operation</Value>
</Value>
<Value name="3">
<Value>argument</Value>
</Value>
</Data>
<DataLocation>^Handheld.InstructionD</DataLocation>
<DefaultData>InstructionDefaultData</DefaultData>
<IdLocation>^Handheld.InstructionD</IdLocation>
<IndexLocation>^Handheld.InstructionI</IndexLocation>
<StreamLocation>^Handheld.InstructionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// Program to create the boot code for an infinite loop for a handheld games console
Class Handheld.Instruction Extends %Persistent
{

Property operation As %String;

Property argument As %Integer;

/// The input is parsed in to an array
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
    /// loop to go through the day8 txt file 
    WHILE ('file.AtEnd)
    {
        set delim="^"
        set line = file.ReadLine()
        write !, "We are within the iterative loop"
        write *32
        write line,!
        set lim = " "
       
       
        
        // Uses $Piece to extract lines parts and assign them to an array called lines
        set instructions(count)=$PIECE(line, delim)        
        //set instructions(count)=$PIECE(lines(count),lim)
        set count = $INCREMENT(count)
    }
        write !,*32
        write !, "Double checking to see if the lines array is set"
        write !,*32
        
        
        write !, "1st iteration of instructions array ", instructions(1)
        write !, "2nd iteration of instructions array ", instructions(2)
        write !, "3rd iteration of instructions array ", instructions(3)
        write !, "End of loop import process complete"
        write *32

        /// Since we have a one dimensional strings within a list we need to transform this in to an array
        /// I have placed the steps to transform this string in to an array of data types below

        // initialised and set up the array
        set instructions=##class(%ArrayOfDataTypes).%New()
                                
        do instructions.SetAt("nop +0","1")
        do instructions.SetAt("jmp +4","3")
        do instructions.SetAt("acc +3","4")
        do instructions.SetAt("jmp -3","5")
        do instructions.SetAt("acc -99","6")
        do instructions.SetAt("acc +1","7")
        do instructions.SetAt("jmp -4","8")
        do instructions.SetAt("acc +6","9")


        write "Done" ,!

        do ..Extraction(.instructions)
}

ClassMethod Extraction(ByRef instructions As %ArrayOfDataTypes, ByRef operation As %String, ByRef argument As %Integer)
{
        // initialise the variables for future use within the function
        set lim = " "
        set count=1
        set accumulator=0
        set position=0
        set visitedinstruc=0
        set exitCode=0
    
                                
        for i=1:1:instructions.Count() 
        {
            write instructions.GetAt(i),!
            // Within the instructions array we will extract the operation array and create a new instance called visited.
            // We save the operation array to the operation property on the object.
            // We will output the results of Operation to the screen
                
            set operation(count)=$PIECE(instructions.GetAt(i), lim)
            set visited=##class(Handheld.Instruction).%New()
            set visited.operation=operation(count)
            write "Operation:",visited.operation ,!
            
            // Within the instructions array we will extract the operation array and create a new instance called visited.
            // We save the argument array to the argument property on the object.
            // We will output the results of Operation to the screen

            
            set argument(count)=$PIECE(instructions.GetAt(i), lim, *)
            set visited.argument=argument(count)
            write "Argument:",visited.argument ,!
                        
            // We are testing the value of visited... to see if it is greater than 0 we do this 
            // so that we can determine if the function has run for the second time or not.
                        
            if visitedinstruc > 0 
            {
                set exitCode = 1
                break
            
            }
                        
            // We will iterate over the operation and look for "acc" and we set the accumulator and position variables
            // After iteration through the loop we will output the result of accumulator to the screen
            // And then return the value of accumulator, position and visited.. 
                        
            if operation(count) = "acc" 
            {
                write "We have acced !" ,!
                set accumulator = visited.argument
                set position = $INCREMENT(position)
            } elseif operation(count) = "jmp" {
                set position = visited.argument
                write "We have jmped" ,!
            } elseif operation(count) = "nop" {
                set position = $INCREMENT(position)
                write "We have noped" ,!
            } else {
                set visitedinstruc = position

            }
            

            write "Accumulator: ",accumulator ,!
            write "Exit code: ",exitCode ,!
            write "Visited Instructions: ",visitedinstruc ,!
            return accumulator, exitCode, visitedinstruc
            
            set count=$INCREMENT(count)
            }
        
            // We save the object and determine if the save was successful or not.

            set status=visited.%Save()
            write "Status is : ", status ,!
            if $$$ISERR(status) {
            do $system.Status.DisplayError(status)
            }
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

pageextension 50059 GenJrnlPageExt extends "General Journal"
{
    layout
    {
        addafter(Description)
        {
            field("Cust. Post. Description ANSMI"; Rec."Cust. Post. Description ANSMI")
            {
                ApplicationArea = all;
            }
        }
    }
}

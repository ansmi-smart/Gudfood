pageextension 50044 SalesReturnOrderArchivePageExt extends "Sales Return Order Archive"
{
    layout
    {
        addlast(General)
        {
            field("Cust. Post. Description ANSMI"; Rec."Cust. Post. Description ANSMI")
            {
                ApplicationArea = All;
            }
        }
    }
}

pageextension 50054 PurchaseInvoiceExt extends "Purchase Invoice"
{
    layout
    {
        addlast(General)
        {
            field("Lines Counter ANSMI"; Rec."Lines Counter ANSMI")
            {
                Caption = 'Lines counter ANSMI';
                ApplicationArea = All;
            }
        }
    }
}
pageextension 50053 PurchaseQuoteExt extends "Purchase Quote"
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
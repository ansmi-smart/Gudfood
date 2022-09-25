pageextension 50057 PurchaseCreditMemoExt extends "Purchase Credit Memo"
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

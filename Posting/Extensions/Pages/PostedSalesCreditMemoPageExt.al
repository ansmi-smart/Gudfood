pageextension 50040 PostedSalesCreditMemoPageExt extends "Posted Sales Credit Memo"
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

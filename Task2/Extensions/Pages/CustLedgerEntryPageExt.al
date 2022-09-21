pageextension 50052 CustLedgerEntryPageExt extends "Customer Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field("Cust. Post. Description ANSMI"; Rec."Cust. Post. Description ANSMI")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }

    }
}
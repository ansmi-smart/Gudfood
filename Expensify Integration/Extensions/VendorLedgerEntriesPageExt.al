pageextension 50067 VendorLedgerEntriesPageExt extends "Vendor Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field("Reimbursable ANSMI"; Rec."Reimbursable ANSMI")
            {
                ApplicationArea = All;
            }
            field("Receipt ANSMI"; Rec."Receipt ANSMI")
            {
                ApplicationArea = All;
            }
        }
    }
}

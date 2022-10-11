tableextension 50064 "Vendor Ledger Entry Extension" extends "Vendor Ledger Entry"
{
    fields
    {
        field(50000; "Reimbursable ANSMI"; Boolean)
        {
            Caption = 'Reimbursable ANSMI';
            DataClassification = ToBeClassified;
        }
        field(50001; "Receipt ANSMI"; Text[512])
        {
            Caption = 'Receipt ANSMI';
            DataClassification = ToBeClassified;
        }
    }
}

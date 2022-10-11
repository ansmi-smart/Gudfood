tableextension 50057 GenJournalLineTableExt extends "Gen. Journal Line"
{
    fields
    {
        field(50000; "Cust. Post. Description ANSMI"; Text[250])
        {
            Caption = 'Cust. Post. Description ANSMI';
            DataClassification = ToBeClassified;
        }
        field(50001; "Lines Counter ANSMI"; Integer)
        {
            Caption = 'Lines Counter ANSMI';
            FieldClass = Normal;
        }
        field(50002; "Reimbursable ANSMI"; Boolean)
        {
            Caption = 'Reimbursable ANSMI';
            DataClassification = ToBeClassified;
        }
        field(50003; "Receipt ANSMI"; Text[512])
        {
            Caption = 'Receipt ANSMI';
            DataClassification = ToBeClassified;
        }
    }
}

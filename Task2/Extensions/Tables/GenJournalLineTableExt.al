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
    }
}

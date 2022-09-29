table 50063 TxtDataTable
{
    Caption = 'TxtDataTable';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; VoNo; Text[250])
        {
            Caption = 'VoNo';
            DataClassification = ToBeClassified;
        }
        field(2; VoDt; Text[250])
        {
            Caption = 'VoDt';
            DataClassification = ToBeClassified;
        }
        field(3; VoTp; Text[250])
        {
            Caption = 'VoTp';
            DataClassification = ToBeClassified;
        }
        field(4; Txt; Text[250])
        {
            Caption = 'Txt';
            DataClassification = ToBeClassified;
        }
        field(5; DbAcCl; Text[250])
        {
            Caption = 'DbAcCl';
            DataClassification = ToBeClassified;
        }
        field(6; DbAcNo; Text[250])
        {
            Caption = 'DbAcNo';
            DataClassification = ToBeClassified;
        }
        field(7; DbTxCd; Text[250])
        {
            Caption = 'DbTxCd';
            DataClassification = ToBeClassified;
        }
        field(8; CrAcCl; Text[250])
        {
            Caption = 'CrAcCl';
            DataClassification = ToBeClassified;
        }
        field(9; CrAcNo; Text[250])
        {
            Caption = 'CrAcNo';
            DataClassification = ToBeClassified;
        }
        field(10; CrTxCd; Text[250])
        {
            Caption = 'CrTxCd';
            DataClassification = ToBeClassified;
        }
        field(11; Cur; Text[250])
        {
            Caption = 'Cur';
            DataClassification = ToBeClassified;
        }
        field(12; ExRt; Text[250])
        {
            Caption = 'ExRt';
            DataClassification = ToBeClassified;
        }
        field(13; CurAm; Text[250])
        {
            Caption = 'CurAm';
            DataClassification = ToBeClassified;
        }
        field(14; AM; Text[250])
        {
            Caption = 'AM';
            DataClassification = ToBeClassified;
        }
        field(15; InvoNo; Text[250])
        {
            Caption = 'InvoNo';
            DataClassification = ToBeClassified;
        }
        field(16; DueDt; Text[250])
        {
            Caption = 'DueDt';
            DataClassification = ToBeClassified;
        }
        field(17; CID; Text[250])
        {
            Caption = 'CID';
            DataClassification = ToBeClassified;
        }
        field(18; AgRef; Text[250])
        {
            Caption = 'AgRef';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; VoNo, Txt, DbAcCl, DbAcNo, DbTxCd, CrAcCl, CrTxCd, CrAcNo, AM)
        {
            Clustered = true;
        }
    }
}

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
        field(9; CrAcNo; Code[20])
        {
            Caption = 'CrAcNo';
            DataClassification = ToBeClassified;
        }
        field(10; CrTxCd; Code[20])
        {
            Caption = 'CrTxCd';
            DataClassification = ToBeClassified;
        }
        field(11; Cur; Code[20])
        {
            Caption = 'Cur';
            DataClassification = ToBeClassified;
        }
        field(12; ExRt; Code[20])
        {
            Caption = 'ExRt';
            DataClassification = ToBeClassified;
        }
        field(13; CurAm; Code[20])
        {
            Caption = 'CurAm';
            DataClassification = ToBeClassified;
        }
        field(14; AM; Text[250])
        {
            Caption = 'AM';
            DataClassification = ToBeClassified;
        }
        field(15; InvoNo; Code[20])
        {
            Caption = 'InvoNo';
            DataClassification = ToBeClassified;
        }
        field(16; DueDt; Text[250])
        {
            Caption = 'DueDt';
            DataClassification = ToBeClassified;
        }
        field(17; CID; Code[20])
        {
            Caption = 'CID';
            DataClassification = ToBeClassified;
        }
        field(18; AgRef; Code[20])
        {
            Caption = 'AgRef';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; VoNo)
        {
            Clustered = true;
        }
    }
}

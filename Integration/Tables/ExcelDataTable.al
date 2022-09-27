table 50060 "Excel Data ANSMI"
{
    Caption = 'Excel Data ANSMI';
    fields
    {
        field(1; "Document/Transaction ID"; Code[20])
        {
            Caption = 'Document/Transaction ID';
        }

        field(2; "GL Account"; Code[20])
        {
            Caption = 'GL Account';
        }
        field(3; "Period"; Date)
        {
            Caption = 'Period';
        }
        field(4; "Amount"; Integer)
        {
            Caption = 'Amount';
        }
        field(5; "PortfolioID/AssetID"; Code[20])
        {
            Caption = 'PortfolioID/AssetID';
        }
        field(6; "Portfolio Description"; Text[100])
        {
            Caption = 'Portfolio Description';
        }
        field(7; "Batch ID"; Code[20])
        {
            Caption = 'Batch ID';
        }
        field(8; "Batch Name"; Text[50])
        {
            Caption = 'Batch Name';
        }
        field(9; "Segment ID"; Code[20])
        {
            Caption = 'Segment ID';
        }

        field(10; "Segment Name"; Text[50])
        {
            Caption = 'Segment Name';
        }
        field(11; "Comment to posting"; Text[250])
        {
            Caption = 'Comment to posting';
        }

    }

    keys
    {
        key(PK; "Document/Transaction ID")
        {
            Clustered = true;
        }
    }
}
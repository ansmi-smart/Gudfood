page 50068 "SMA Expensify Setup ANSMI"
{
    Caption = 'SMA Expensify Setup ANSMI';
    SourceTable = "SMA Expensify Setup ANSMI";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("partnerUserID "; Rec."partnerUserID ")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the partnerUserID  field.';
                }
                field("partnerUserSecret "; Rec."partnerUserSecret ")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the partnerUserSecret  field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Get API Expencify Integration")
            {
                Caption = 'Get API Expencify Integration ANSMI';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = report "SMA Expensify Integ. ANSMI";
            }
        }
    }
}

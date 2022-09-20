page 50055 "Set Description ANSMI Wizard"
{
    Caption = 'Set up Cust. Post. Description ANSMI';
    PageType = NavigatePage;
    SourceTable = "Sales Header";

    layout
    {
        area(content)
        {
            group(StandardBanner)
            {
                Caption = '';
                Editable = false;
                Visible = TopBannerVisible and not FinishActionEnabled;
                field(MediaResourcesStandard; MediaResourcesStandard."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(FinishedBanner)
            {
                Caption = '';
                Editable = false;
                Visible = TopBannerVisible and FinishActionEnabled;
                field(MediaResourcesDone; MediaResourcesDone."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group("Step1")
            {
                Visible = Step1Visible;
                group("Welcome to Cust. Post. Description ANSMI field insertion setup!")
                {
                    Visible = Step1Visible;
                    group(Welcome)
                    {
                        ShowCaption = false;
                        InstructionalText = 'Now you can insert text to Cust. Post. Description ANSMI field in Sales Order';
                    }
                }
                group("Let`s go!")
                {
                    Caption = 'Let''s go!';
                    group(Next)
                    {
                        ShowCaption = false;
                        InstructionalText = 'Choose Next to start.';
                    }
                }
            }
            group("Step2")
            {
                Caption = 'Add description';
                InstructionalText = 'Write your description';
                Visible = Step2Visible;
                field("Cust. Post. Description ANSMI"; Rec."Cust. Post. Description ANSMI")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Custom Posting Description ANSMI field.';
                }
            }
            group(Step3)
            {
                Visible = Step3Visible;
                group(Ok)
                {
                    Caption = 'Ok!';
                    InstructionalText = 'Congratulations! - You have finished the setup.';
                }
                group(TheEnd)
                {
                    Caption = 'That''s it!';
                    group(last)
                    {
                        ShowCaption = false;
                        InstructionalText = 'For saving, press Finish.';
                    }
                }
            }
        }

    }
    actions
    {
        area(processing)
        {
            action(ActionBack)
            {
                ApplicationArea = All;
                Caption = 'Back';
                Enabled = BackActionEnabled;
                Image = PreviousRecord;
                InFooterBar = true;
                trigger OnAction();
                begin
                    NextStep(true);
                end;
            }
            action(ActionNext)
            {
                ApplicationArea = All;
                Caption = 'Next';
                Enabled = NextActionEnabled;
                Image = NextRecord;
                InFooterBar = true;
                trigger OnAction();
                begin
                    NextStep(false);
                end;
            }
            action(ActionFinish)
            {
                ApplicationArea = All;
                Caption = 'Finish';
                Enabled = FinishActionEnabled;
                Image = Approve;
                InFooterBar = true;
                trigger OnAction();
                begin
                    CurrPage.Close();
                end;
            }
        }
    }

    trigger OnInit()
    begin
        LoadTopBanners();
    end;

    trigger OnOpenPage()
    var
        SalesHeader: Record "Sales Header";
    begin
        Step := Step::Start;
        EnableControls();
    end;

    var
        Step1Visible: Boolean;
        Step2Visible: Boolean;
        Step3Visible: Boolean;
        Step: Option Start,Step2,Finish;
        BackActionEnabled: Boolean;
        NextActionEnabled: Boolean;
        FinishActionEnabled: Boolean;
        TopBannerVisible: Boolean;
        MediaRepositoryDone: Record "Media Repository";
        MediaRepositoryStandard: Record "Media Repository";
        MediaResourcesDone: Record "Media Resources";
        MediaResourcesStandard: Record "Media Resources";

    local procedure EnableControls()
    begin
        ResetControls();

        case Step of
            Step::Start:
                ShowStep1();
            Step::Step2:
                ShowStep2();
            Step::Finish:
                ShowStep3();
        end;
    end;

    local procedure ResetControls()
    begin
        FinishActionEnabled := false;
        BackActionEnabled := true;
        NextActionEnabled := true;

        Step1Visible := false;
        Step2Visible := false;
        Step3Visible := false;
    end;

    local procedure ShowStep1()
    begin
        Step1Visible := true;

        FinishActionEnabled := false;
        BackActionEnabled := false;
    end;

    local procedure ShowStep2()
    begin
        Step2Visible := true;
    end;

    local procedure ShowStep3()
    begin
        Step3Visible := true;

        FinishActionEnabled := true;
        BackActionEnabled := true;
        NextActionEnabled := false;
    end;

    local procedure NextStep(Back: Boolean)
    begin
        if Back then
            Step := Step - 1
        else
            Step := Step + 1;

        EnableControls();
    end;

    local procedure LoadTopBanners();
    begin
        if MediaRepositoryStandard.Get('AssistedSetup-NoText-400px.png', Format(CurrentClientType())) and
            MediaRepositoryDone.Get('AssistedSetupDone-NoText-400px.png', Format(CurrentClientType()))
        then
            if MediaResourcesStandard.Get(MediaRepositoryStandard."Media Resources Ref") and
                MediaResourcesDone.Get(MediaRepositoryDone."Media Resources Ref")
        then
                TopBannerVisible := MediaResourcesDone."Media Reference".HasValue();
    end;
}
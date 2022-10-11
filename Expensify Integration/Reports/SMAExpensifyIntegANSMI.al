report 50067 "SMA Expensify Integ. ANSMI"
{
    ApplicationArea = All;
    Caption = 'SMA Expensify Integ. ANSMI';
    UsageCategory = Documents;
    DefaultLayout = Word;
    WordLayout = 'Expensify.docx';

    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            column(Journal_Template_Name; "Journal Template Name")
            {
            }
            column(Journal_Batch_Name; "Journal Batch Name")
            {

            }
        }

        dataitem("SMA Expensify Setup ANSMI"; "SMA Expensify Setup ANSMI")
        {
            column(partnerUserID_; "partnerUserID ")
            {

            }
            column(partnerUserSecret_; "partnerUserSecret ")
            {

            }
        }
    }
}

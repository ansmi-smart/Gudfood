report 50071 "Excel Report"
{
    Caption = 'ANSMI Excel Report';
    ProcessingOnly = true;

    dataset
    {
        dataitem("SalesHeader"; "Sales Header")
        {   //company info
            column(CompanyName; CompanyInfo.Name)
            {

            }
            column(CompanyAddress; CompanyInfo.Address)
            {

            }
            column(CompanyInfo; CompanyInfo."Registration No.")
            {

            }

            //sell-to customer
            column(SelltoCustomerNo; "Sell-to Customer No.")
            {
            }
            column(SelltoCustomerName; "Sell-to Customer Name")
            {
            }
            column(SelltoCounty; "Sell-to County")
            {
            }
            column(SelltoCity; "Sell-to City")
            {
            }
            column(SelltoAddress; "Sell-to Address")
            {
            }

            column(SelltoPhoneNo; "Sell-to Phone No.")
            {
            }

            //lines
            dataitem(SalesLines; "Sales Line")
            {
                column("Code"; "No.")
                {

                }
                column(Description; "Description")
                {

                }
                column(Quantity; "Quantity")
                {

                }
                column(UnitPrice; "Unit Price")
                {

                }
                column(LineAmount; "Line Amount")
                {

                }

                //totals
                column(Amount; Amount)
                {

                }
                column(VATAmount; VATAmount)
                {
                    //AmountIncludingVAT-Amount
                }
                column(AmountIncludingVAT; "Amount Including VAT")
                {

                }
            }

            trigger OnAfterGetRecord()
            begin
                FillLinesWithData();
            end;
        }
    }
    var
        CompanyInfo: Record "Company Information";
        dsf: page "Excel Templates";
        VATAmount: Decimal;
        ExcelReportBuilderManager: Codeunit "Excel Report Builder Manager";

    trigger OnPreReport()
    begin
        InitTemplate();
        ExcelReportBuilderManager.SetSheet('Sheet1');
        ExcelReportBuilderManager.AddSection('SalesHeader');
    end;

    local procedure InitTemplate()
    begin
        ExcelReportBuilderManager.InitTemplate('ANSMISales');
    end;

    local procedure FillLinesWithData()
    begin
        ExcelReportBuilderManager.AddSection('SalesHesder');
        ExcelReportBuilderManager.AddDataToSection('CompanyName', CompanyInfo.Name);
        ExcelReportBuilderManager.AddDataToSection('Address', CompanyInfo.Address);
        ExcelReportBuilderManager.AddDataToSection('RegistrationNo', CompanyInfo."Registration No.");

        ExcelReportBuilderManager.AddDataToSection('CustomerName', SalesHeader."Sell-to Customer Name");
        ExcelReportBuilderManager.AddDataToSection('CustomerAddress', SalesHeader."Sell-to Address");
        ExcelReportBuilderManager.AddDataToSection('CustomerPhoneNo', SalesHeader."Sell-to Phone No.");

        ExcelReportBuilderManager.AddSection('SalesLines');
        ExcelReportBuilderManager.AddDataToSection('ItemNo', SalesLines."No.");
        ExcelReportBuilderManager.AddDataToSection('Description', SalesLines.Description);
        ExcelReportBuilderManager.AddDataToSection('Quantiy', Format(SalesLines.Quantity));
        ExcelReportBuilderManager.AddDataToSection('UnitPrice', Format(SalesLines."Unit Price"));
        ExcelReportBuilderManager.AddDataToSection('Amount', Format(SalesLines.Amount));
    end;
}

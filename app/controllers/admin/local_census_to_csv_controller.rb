require 'rubyXL'
require 'rubyXL/convenience_methods/cell'
require 'rubyXL/convenience_methods/worksheet'
require 'roo'

class Admin::LocalCensusToCsvController < Admin::BaseController

  def index
  end

  def create
    # Save errors found in the excel file
    @errors = []
    workbook = RubyXL::Parser.parse_buffer(params[:excel].read)
    worksheet = workbook[0]

    # Join the document type (DNI, passport...) and letter if they are detached
    worksheet.each_with_index do |cell, index|
      index = index + 1
      if cell[7] && cell[7].value && cell[6] && cell[6].value
        cell[6].change_contents(cell[6].value.to_s + cell[7].value.to_s)
      end
    end

    # Columns that will be delete
    columns_to_delete = [0,0,0,0,0,2,3,3,3,3,3,3,3]
    columns_to_delete.each do |index|
      worksheet.delete_column(index)
    end

    # Change names columns
    if !worksheet[0][1]
      worksheet.add_cell(0,1,'document_number')
    else
      worksheet[0][1].change_contents('document_number')
    end
    worksheet[0][0].change_contents('document_type')
    worksheet[0][2].change_contents('date_of_birth')

    # insert postal_code column
    worksheet.insert_column(3)

    # Change document_type for its number
    documents_type = {
      'document_type' => 'document_type',
      'PASAPORTE' => '2',
      'D.N.I.' => '1',
      'TARJETA RESIDENCIA' => '3'
    }
    
    worksheet.each_with_index do |cell, index|
      if cell[0] && cell[0].value
        cell[0].change_contents(documents_type[cell[0].value])
      else
        @errors.push(t("admin.excel_to_csv.errors", index: (index + 1).to_s))
      end
      # Set Postal Code Value
      worksheet.add_cell(index, 3, '28410')
    end

    # Set Title for postal_code column
    worksheet.add_cell(0, 3, 'postal_code')

    # return the csv file or return the template index
    if !@errors.empty? && params[:skip_blank] == 1.to_s
      xlsx = Roo::Excelx.new(workbook.stream)
      csvStream = xlsx.to_csv() # return a StringIO if it doesn't have a filename as parameter
      send_data(csvStream, {filename: 'censo.csv'})
    else
      render 'index'
    end
  end

end

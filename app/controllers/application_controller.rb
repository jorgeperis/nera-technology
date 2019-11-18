class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: ENV['NERA_USER'], password: ENV['NERA_PASS']

  def download_excel
    files = params[:download_excel][:files]

    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(:name => "Pesos individuales") do |sheet|
        files.each do |file|
          data = Hash.from_xml(file.open)

          array_data = data["XSerie"]["TEXT"]["s"]
          fecha = array_data[1]
          measures = array_data.select{ |i| i[/\d{1,}\:\s*\-?\d{1,3}\,\d{2}\s\g/] }
          measures_data = measures.map do |measure|
            measure[/\-?\d{1,3}\,\d{2}/].gsub(',', '.').to_f
          end

          sheet.add_row measures_data.prepend(fecha)
        end
        sheet.add_row([])
        sheet.add_row(['Powered by Nera Technology'])
      end

      p.serialize('pesos_agrupados.xlsx')

      send_data p.to_stream.read, type: "application/xlsx", filename: 'pesos_agrupados.xlsx'
    end
  end
end

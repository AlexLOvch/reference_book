# encoding: utf-8
ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => "Справочники" do

    Referencebook.all.each do |referencebook|
        panel "#{referencebook.name}" do
          table do
            tr do 
              referencebook.attribs.each_with_index do |attrib,i|
                th attrib.name
              end  
            end
            referencebook.records.each_with_index do |record,i|
              tr do 
                record[:attribs].each do |attrib|
                  td attrib[0][:data]
                end  
              end  
            end
          end
        end
    end    
  end # content
end

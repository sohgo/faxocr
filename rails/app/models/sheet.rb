# -*- coding: utf-8 -*-
class Sheet < ActiveRecord::Base

  belongs_to :survey
  has_many :answer_sheets, :dependent => :destroy
  has_many :sheet_properties, :dependent => :destroy

  validates_presence_of :sheet_code, :sheet_name, :survey_id
  validates_uniqueness_of :sheet_code
  STATUS = [["クローズ", 0], ["オープン", 1], ["中断", 2], ["期間終了", 3]]

  def get_one_srml_entry
    generate_one_srml_entry(self)
  end

  def generate_one_srml_entry(sheet)
    srmlstr = ""
    srmlstr = srmlstr + "  <sheet>\n"
    srmlstr = srmlstr + "    <id>#{sheet.sheet_code}</id>\n"
    srmlstr = srmlstr + "    <blockWidth>" + (sheet.block_width).to_s + "</blockWidth>\n"
    srmlstr = srmlstr + "    <blockHeight>" + (sheet.block_height).to_s + "</blockHeight>\n"
    srmlstr = srmlstr + "    <cellWidth>\n"
    eval(sheet.cell_width).sort.each do |cell_no,cell_width|
      srmlstr = srmlstr + "      <cellAttribute number=\"#{cell_no}\" length=\"#{cell_width}\"/>\n"
    end
    srmlstr = srmlstr + "    </cellWidth>\n"
    srmlstr = srmlstr + "    <cellHeight>\n"
    eval(sheet.cell_height).sort.each do |cell_no,cell_height|
      srmlstr = srmlstr + "      <cellAttribute number=\"#{cell_no}\" length=\"#{cell_height}\"/>\n"
    end
    srmlstr = srmlstr + "    </cellHeight>\n"
    srmlstr = srmlstr + "    <properties>\n"
    srmlstr = srmlstr + "      <blockOcr"
    srmlstr = srmlstr + " name=\"echo_request_and_send_analyzed_data\""
    srmlstr = srmlstr + " x=\"" + (sheet.block_width).to_s + "\""
    srmlstr = srmlstr + " y=\"" + (sheet.block_height).to_s + "\""
    srmlstr = srmlstr + " colspan=\"1\""
    srmlstr = srmlstr + " option=\"rating\""
    srmlstr = srmlstr + "/>\n"
    if sheet.sheet_properties != nil
      sheet.sheet_properties.each do |property|
        escaped_ocr_name = REXML::Text::normalize(property.survey_property.ocr_name, nil, nil)
        if property.survey_property.data_type == "image"
          srmlstr = srmlstr + "      <blockImg"
          srmlstr = srmlstr + " name=\"#{escaped_ocr_name}\""
          srmlstr = srmlstr + " x=\"" + (property.position_x).to_s + "\""
          srmlstr = srmlstr + " y=\"" + (property.position_y).to_s + "\""
          srmlstr = srmlstr + " colspan=\"#{property.colspan}\""
          srmlstr = srmlstr + " margin=\"15\""
          srmlstr = srmlstr + "/>\n"
        else
          srmlstr = srmlstr + "      <blockOcr"
          srmlstr = srmlstr + " name=\"#{escaped_ocr_name}\""
          srmlstr = srmlstr + " x=\"" + (property.position_x).to_s + "\""
          srmlstr = srmlstr + " y=\"" + (property.position_y).to_s + "\""
          srmlstr = srmlstr + " colspan=\"#{property.colspan}\""
          srmlstr = srmlstr + " option=\"#{property.survey_property.data_type}\""
          srmlstr = srmlstr + "/>\n"
          srmlstr = srmlstr + "      <blockImg"
          srmlstr = srmlstr + " name=\"#{escaped_ocr_name}\""
          srmlstr = srmlstr + " x=\"" + (property.position_x).to_s + "\""
          srmlstr = srmlstr + " y=\"" + (property.position_y).to_s + "\""
          srmlstr = srmlstr + " colspan=\"#{property.colspan}\""
          srmlstr = srmlstr + " margin=\"15\""
          srmlstr = srmlstr + "/>\n"
        end
      end
    end
    srmlstr = srmlstr + "    </properties>\n"
    srmlstr = srmlstr + "  </sheet>\n"
    srmlstr
  end
end

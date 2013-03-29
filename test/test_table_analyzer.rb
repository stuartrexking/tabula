# -*- coding: utf-8 -*-
require 'open3'
require 'tmpdir'

require 'minitest/autorun'

require_relative '../local_settings'
require_relative '../lib/tabula'
require_relative '../lib/parse_xml.rb'

class TestTableAnalyzer < MiniTest::Unit::TestCase
  def setup
    @tmp_dir = Dir.mktmpdir
  end

  def teardown
    FileUtils.remove_entry_secure @tmp_dir
  end

  def test_argentina_diputados_voting_record
    run_jruby_extractor!('test_pdfs/argentina_diputados_voting_record.pdf')

    text_elements = Tabula::XML.get_text_elements(@tmp_dir, 1, 12.75, 269.875, 561, 790.5)
    table = Tabula.make_table(text_elements)

    # a "normal" file.
    expected = [["ABDALA de MATARAZZO, Norma Amanda", "Frente Cívico por Santiago", "Santiago del Estero", "AFIRMATIVO"], ["ALBRIEU, Oscar Edmundo Nicolas", "Frente para la Victoria - PJ", "Rio Negro", "AFIRMATIVO"], ["ALONSO, María Luz", "Frente para la Victoria - PJ", "La Pampa", "AFIRMATIVO"], ["ARENA, Celia Isabel", "Frente para la Victoria - PJ", "Santa Fe", "AFIRMATIVO"], ["ARREGUI, Andrés Roberto", "Frente para la Victoria - PJ", "Buenos Aires", "AFIRMATIVO"], ["AVOSCAN, Herman Horacio", "Frente para la Victoria - PJ", "Rio Negro", "AFIRMATIVO"], ["BALCEDO, María Ester", "Frente para la Victoria - PJ", "Buenos Aires", "AFIRMATIVO"], ["BARRANDEGUY, Raúl Enrique", "Frente para la Victoria - PJ", "Entre Ríos", "AFIRMATIVO"], ["BASTERRA, Luis Eugenio", "Frente para la Victoria - PJ", "Formosa", "AFIRMATIVO"], ["BEDANO, Nora Esther", "Frente para la Victoria - PJ", "Córdoba", "AFIRMATIVO"], ["BERNAL, María Eugenia", "Frente para la Victoria - PJ", "Jujuy", "AFIRMATIVO"], ["BERTONE, Rosana Andrea", "Frente para la Victoria - PJ", "Tierra del Fuego", "AFIRMATIVO"], ["BIANCHI, María del Carmen", "Frente para la Victoria - PJ", "Cdad. Aut. Bs. As.", "AFIRMATIVO"], ["BIDEGAIN, Gloria Mercedes", "Frente para la Victoria - PJ", "Buenos Aires", "AFIRMATIVO"], ["BRAWER, Mara", "Frente para la Victoria - PJ", "Cdad. Aut. Bs. As.", "AFIRMATIVO"], ["BRILLO, José Ricardo", "Movimiento Popular Neuquino", "Neuquén", "AFIRMATIVO"], ["BROMBERG, Isaac Benjamín", "Frente para la Victoria - PJ", "Tucumán", "AFIRMATIVO"], ["BRUE, Daniel Agustín", "Frente Cívico por Santiago", "Santiago del Estero", "AFIRMATIVO"], ["CALCAGNO, Eric", "Frente para la Victoria - PJ", "Buenos Aires", "AFIRMATIVO"], ["CARLOTTO, Remo Gerardo", "Frente para la Victoria - PJ", "Buenos Aires", "AFIRMATIVO"], ["CARMONA, Guillermo Ramón", "Frente para la Victoria - PJ", "Mendoza", "AFIRMATIVO"], ["CATALAN MAGNI, Julio César", "Frente para la Victoria - PJ", "Tierra del Fuego", "AFIRMATIVO"], ["CEJAS, Jorge Alberto", "Frente para la Victoria - PJ", "Rio Negro", "AFIRMATIVO"], ["CHIENO, María Elena", "Frente para la Victoria - PJ", "Corrientes", "AFIRMATIVO"], ["CIAMPINI, José Alberto", "Frente para la Victoria - PJ", "Neuquén", "AFIRMATIVO"], ["CIGOGNA, Luis Francisco Jorge", "Frente para la Victoria - PJ", "Buenos Aires", "AFIRMATIVO"], ["CLERI, Marcos", "Frente para la Victoria - PJ", "Santa Fe", "AFIRMATIVO"], ["COMELLI, Alicia Marcela", "Movimiento Popular Neuquino", "Neuquén", "AFIRMATIVO"], ["CONTI, Diana Beatriz", "Frente para la Victoria - PJ", "Buenos Aires", "AFIRMATIVO"], ["CORDOBA, Stella Maris", "Frente para la Victoria - PJ", "Tucumán", "AFIRMATIVO"], ["CURRILEN, Oscar Rubén", "Frente para la Victoria - PJ", "Chubut", "AFIRMATIVO"]]

    assert_equal lines_to_array(table), expected
  end

  def test_pharma_spaceless
    run_jruby_extractor!('test_pdfs/ClinicalResearchDisclosureReport2012Q2.pdf')

    text_elements = Tabula::XML.get_text_elements(@tmp_dir, 1, 49.9375, 85, 537.625, 130.6875)
    table = Tabula.make_table(text_elements)

    # this file does not get spaces rendered by pdfbox (so XML lacks spaces) but
    # Tabula.make_table should add spaces.
    expected = [["ABRAHAM RESEARCH, PLLC", "VILLAREAL, MANUEL", "CRESCENT SPRINGS, ", "KY", "$", "3,748.70"], ["ABRAHAM RESEARCH, PLLC", "TELTSER, MATTHEW", "PEMBROKE PINES, FL", "$", "6,000.00"], ["ALBEMARLE RESEARCH CONSULTANTS, INC. CAROLINA ", "RESEARCH ", "SPECIALISTS", "HEYDER, ALBRECHT M.", "ELIZABETH CITY, NC", "$", "2,565.00"], ["ALBUQUERQUE NEUROSCIENCE, INC.", "DEMPSEY, GLENN MICHAEL", "ALBUQUERQUE, NM", "$", "71,955.50"], ["ALEXIAN BROTHERS BEHAVIORIAL HEALTH HOSPITAL", "LERMAN, MARK", "CHICAGO, IL", "$", "14,079.00"], ["ALLERGIC DISEASES SC", "COHEN, STEVEN H.", "WEST ALLIS, WI", "$", "1,786.00"]]

    assert_equal lines_to_array(table), expected
  end

  def test_bo_page24
    run_jruby_extractor!('test_pdfs/bo_page24.pdf')
    # Request URL:http://localhost:9393/pdf/d1bfae1be8d6b099c1b7bb7b401ca97310e61063/data?x1=50.089285714285715&x2=809.0178571428571&y1=432.5892857142857&y2=490.2678571428571&page=1

    text_elements = Tabula::XML.get_text_elements(@tmp_dir, 1, 50.089, 432.589, 809.017, 490.267)
    table = Tabula.make_table(text_elements)

    expected = [["1", "UNICA", "CECILIA KANDUS", "16/12/2008", "PEDRO ALBERTO GALINDEZ", "60279/09"], ["1", "UNICA", "CECILIA KANDUS", "10/06/2009", "PASTORA FILOMENA NAVARRO", "60280/09"], ["13", "UNICA", "MIRTA S. BOTTALLO DE VILLA", "02/07/2009", "MARIO LUIS ANGELERI, DNI 4.313.138", "60198/09"], ["16", "UNICA", "LUIS PEDRO FASANELLI", "22/05/2009", "PETTER o PEDRO KAHRS", "60244/09"]]

    assert_equal lines_to_array(table), expected
  end

  private

  def lines_to_array(lines)
    lines.map { |l|
      l.text_elements.map { |te| te.text }
    }
  end

  def run_jruby_extractor!(pdf_path)
    jruby_script_path = File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib/jruby_dump_characters.rb')
    jar_path = File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib/jars')
    jars = File.join(jar_path, 'pdfbox-app-1.8.0.jar')
    system({'CLASSPATH' => jars}, "#{Settings::JRUBY_PATH} --1.9 --server #{jruby_script_path} #{pdf_path} #{@tmp_dir} > /dev/null 2>&1")
  end
end

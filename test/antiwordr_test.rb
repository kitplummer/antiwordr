require 'test/unit'
require File.join(File.dirname(__FILE__), '../lib/antiwordr')

class DocFileTest < Test::Unit::TestCase
  include AntiWordR

  CURRENT_DIR = File.dirname(File.expand_path(__FILE__)) + "/"
  TEST_DOC_PATH = CURRENT_DIR + "test.doc"
  TEST_BAD_PATH = "blah.doc"
  TEST_NON_DOC = CURRENT_DIR + "antiwordr_test.rb"
  TEST_URL_DOC =
   "http://github.com/kitplummer/antiwordr/raw/master/test/test.doc"
  TEST_URL_NON_DOC =
   "http://github.com/kitplummer/antiwordr/raw/master/test/antiwordr_test.rb"
  
  def test_docfile_new
    file = DocFilePath.new(TEST_DOC_PATH, ".")
    assert file
  end
  
  def test_invalid_docfile
    e = assert_raise AntiWordRError do 
      file = DocFilePath.new(TEST_NON_DOC, ".")
      file.convert
    end
    assert_equal "Source document is not a Word Document", e.to_s
  end

  def test_bad_docfile_new
    e = assert_raise AntiWordRError do
      file = DocFilePath.new(TEST_BAD_PATH, ".")
    end
    assert_equal "invalid file path", e.to_s
  end

  def test_string_from_docfile
    file = DocFilePath.new(TEST_DOC_PATH, ".")
    assert_equal "String", file.convert().class.to_s
    assert_equal `antiword "#{TEST_DOC_PATH}"`, file.convert() 
  end 

  def test_return_docbook
    file = DocFilePath.new(TEST_DOC_PATH, ".")
    assert_equal "String", file.convert_to_docbook().class.to_s
  end

  def test_return_docbook_document
    file = DocFilePath.new(TEST_DOC_PATH, ".")
    assert_equal "Nokogiri::XML::Document",
    file.convert_to_docbook_document().class.to_s
    assert_equal Nokogiri::XML.parse(
    `antiword -x db "#{TEST_DOC_PATH}"`
    ).css('para').first.to_s,
    file.convert_to_docbook_document().css('para').first.to_s
  end

  def test_invalid_URL_docfile
    e = assert_raise AntiWordRError do
      file = DocFileUrl.new("blah", ".")
    end
    assert_equal "invalid file url", e.to_s
  end

  def test_invalid_URL_resource_docfile
    e = assert_raise AntiWordRError do
      file = DocFileUrl.new("http://github.com/kitplummer/blah", ".")
    end
    assert_equal "404 Not Found", e.to_s
  end

  def test_invalid_URL_docfile
    e = assert_raise AntiWordRError do
      file = DocFileUrl.new(TEST_URL_NON_DOC, ".")
      file.convert
    end
    assert_equal "Source document is not a Word Document", e.to_s
  end

  def test_valid_URL_docfile
    # http://github.com/kitplummer/pdftohtmlr/raw/master/test/test.pdf
    file = DocFileUrl.new(TEST_URL_DOC)
    assert_equal "String", file.convert().class.to_s
    assert_equal `antiword "#{TEST_DOC_PATH}"`, file.convert()
  end

end
# The library has a single method for converting PDF files into HTML. The
# method current takes in the source path, and either/both the user and owner
# passwords set on the source PDF document.  The convert method returns the
# HTML as a string for further manipulation of loading into a Document.
#
# Requires that pdftohtml be installed and on the path
#
# Author:: Kit Plummer (mailto:kitplummer@gmail.com)
# Copyright:: Copyright (c) 2010 Kit Plummer
# License:: MIT

require 'rubygems'
require 'nokogiri'
require 'uri'
require 'open-uri'
require 'tempfile'

module AntiWordR
  
  # Simple local error abstraction
  class AntiWordRError < RuntimeError; end
  
  VERSION = '0.1.0'

  # Provides facilities for converting Word Docs to Text rom Ruby code.
  class DocFile
    attr :path
    attr :target
    attr :format
    
    def initialize(input_path, target_path=nil)
      @path = input_path
      @target = target_path
    end

    # Convert the PDF document to HTML.  Returns a string
    def convert()
      errors = ""
      output = ""
      
      cmd = "antiword #{format}" + ' "' + @path + '"'
      
      output = `#{cmd} 2>&1`
      
      if (output.include?("command not found"))
        raise AntiWordRError, "AntiWordR requires antiword to be installed"
      elsif (output.include?("is not a Word Document"))
        raise AntiWordRError, "Source document is not a Word Document"
      elsif (output.include?("Error:"))
        raise AntiWordRError, output.split("\n").first.to_s.chomp
      else
        return output
      end
    end
    
    # Convert the PDF document to HTML.  Returns a Nokogiri::HTML:Document
    def convert_to_docbook_document() 
      Nokogiri::XML.parse(convert_to_docbook())
    end
    
    def convert_to_docbook()
      @format = "-x db"
      convert()
    end
  end
  
  # Handle a string-based local path as input, extends PdfFile
  class DocFilePath < DocFile
    def initialize(input_path, target_path=nil)
      # check to make sure file is legit
      if (!File.exist?(input_path))
        raise AntiWordRError, "invalid file path"
      end
      
      super(input_path, target_path)
      
    end 
  end
  
  # Handle a URI as a remote path to a PDF, extends PdfFile
  class DocFileUrl < DocFile
    def initialize(input_url, target_path=nil)
      # check to make sure file is legit
      begin
        if ((input_url =~ URI::regexp).nil?)
          raise AntiWordRError, "invalid file url"
        end
        tempfile = Tempfile.new('antiwordr')
        File.open(tempfile.path, 'wb') {|f| f.write(open(input_url).read) }
        super(tempfile.path, target_path)
      rescue => bang
        raise AntiWordRError, bang.to_s
      end
    end
  end
end
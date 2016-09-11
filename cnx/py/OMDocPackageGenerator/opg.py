#!/usr/bin/env python
"""
Name
  OMDoc Package Generator

Synopsis
  opg.py [options] file

Description
  Generates OMDoc packages based on OMDoc files.
  (see M. Kohlhase, Open Markup Format for Mathematical Documents, p.239)

Options:
  -h, --help              show this help
  -d                      show debugging information while processing
  -r, --recursive         create OMDoc packages recursively (all theory imports are recognized)
  -i, --include           use specified XSLT template to generate the link table for
                          the source file.
  -p, --presentation      use specified XSLT template to compile the content of 
                          OMDoc presentation and omstyle elements in the source file
                          into XSLT templates
  -t, --transformation    use specified XSLT template to generate e.g. file2pmml.xsl
  -c, --catalog           the XML catalog to use. If not set libxml2 will by default check
                          the presence of a catalog in /etc/xml/catalog or using the
                          XML_CATALOG_FILES environment variable

Examples
  opg.py -p expres.xsl -i exincl.xsl -t omdoc2pmml.xsl arith1.omdoc
  
  reads from arith1.omdoc to generate the OMDoc package consisting of
  arith1-tmpl.xsl, artith1-incl.xsl, arith12pmml and arith1.xml
  
Author
  Normen Mueller (n.mueller@iu-bremen.de)
  
Version
  0.2b
  $LastChangedRevision: 5252 $
  $LastChangedDate: 2006-01-18 18:38:52 +0100 (Wed, 18 Jan 2006) $
  
Thanks
  Brent Hendricks (http://rhaptos.org/)
  Daniel Veillard (http://xmlsoft.org/XSLT/python.html)

License
  This program is part of the OMDoc project (http://www.mathweb.org/omdoc/).

  This software is subject to the provisions of the GNU Lesser General
  Public License Version 2.1 (LGPL).  See LICENSE.txt for details.
"""

import libxml2
import libxslt
import sys
import os
import getopt
from sets import Set  
   
    
class OMDocPackageGenerator:
  """...."""
  OPG_ERR_ATT = 1
  OPG_ERR_PARSE = 2
  OPG_ERR_XSLT_PRES = 3
  OPG_ERR_XSLT_INCL = 4
  OPG_ERR_XSLT_TRANS = 5
  OPG_ERR_THEORY = 6
  OPG_ERR_XSLT = 7
  OPG_ERR_XSLT_PROC = 8
  
  def __init__(self):
    # force the libxml2 processor to generate DOM trees compliant with the XPath data model   
    libxml2.lineNumbersDefault(1)
    libxml2.substituteEntitiesDefault(1)
    #
    self.inFile = None
    #
    self.inPath = None
    # traverse all imported theories
    self.recursive = False
    # 
    self.xsltInclFileName = None
    #
    self.xsltPresFileName = None
    #
    self.xsltTransFileName = None
    #
    self.theories = {}
    #
    self.errorno = 0
    
  def setXSLTInclFile(self, xsltInclFileName):
    """..."""
    if xsltInclFileName != None:
      self.xsltInclFileName = xsltInclFileName
      if "~" in self.xsltInclFileName:
        self.xsltInclFileName = xsltInclFileName.replace("~", os.path.expanduser("~"))       
    else:
      self.xsltInclFileName = None
    
  def setXSLTPresFile(self, xsltPresFileName):
    """..."""
    if xsltPresFileName != None:
      self.xsltPresFileName = xsltPresFileName
      if "~" in self.xsltPresFileName:
        self.xsltPresFileName = xsltPresFileName.replace("~", os.path.expanduser("~"))       
    else:
      self.xsltPresFileName = None
    
  def setXSLTTransFile(self, xsltTransFileName):
    """..."""
    if xsltTransFileName != None:
      self.xsltTransFileName = xsltTransFileName
      if "~" in self.xsltTransFileName:
        self.xsltTransFileName = xsltTransFileName.replace("~", os.path.expanduser("~"))       
    else:
      self.xsltTransFileName = None
    
  def setXMLCatalog(self, xmlCatalogFileName):
    """..."""
    if xmlCatalogFileName != None:
      self.xmlCatalogFileName = xmlCatalogFileName
      if "~" in self.xmlCatalogFileName:
        self.xmlCatalogFileName = xmlCatalogFileName.replace("~", os.path.expanduser("~"))
      libxml2.loadCatalog(self.xmlCatalogFileName)        
    else:
      self.xmlCatalogFileName = None
    libxml2.initializeCatalog()     
    
  def setInputFile(self, file, recursive):
    """..."""
    if file != None:
      (self.inPath, self.inFile) = os.path.split(file)
      if self.inPath != None and "~" in self.inPath:
        self.inPath = self.inPath.replace("~", os.path.expanduser("~"))
    else:
      self.inPath = None
      self.inFile = None
    self.recursive = recursive
    
  def getLastError(self):
    """Get last error number."""
    return self.errorno
    
  def build(self):
    """Build OMDoc package
    
    @return True if succeeded, False otherwise."""
    ret = True
    if self._checkAttributes():
      # add initial theory
      doc = self._parseAndLoadFile(os.path.join(self.inPath, self.inFile))
      if doc != None:
        self.theories[os.path.join(self.inPath, self.inFile)] = doc
        # retrieve all theory imports
        ok = True
        if self.recursive:
          ok = self._getAllTheories(self.theories[os.path.join(self.inPath, self.inFile)])
        # build package components
        if ok:
          for cur in self.theories:
            # build output file names
            (fileNameShort, fileExt) = os.path.splitext(cur)
            outInclFileName = fileNameShort + "-incl.xsl"
            outPresFileName = fileNameShort + "-tmpl.xsl"  
            outTransFileName = fileNameShort + self.xsltTransFileName[self.xsltTransFileName.index("2"):]
            
            ok = self._processXSLTPres(self.theories[cur], outPresFileName)
            if ok:
              ok = self._processXSLTIncl(self.theories[cur], outPresFileName, outInclFileName)
              if ok:
                ok = self._generateXSLT(outInclFileName, outTransFileName)
              else:
                ret = False
                break
            else:
              ret = False
              break
          if ok:
            # build XML files 
            for cur in self.theories:
              # build output file names
              (fileNameShort, fileExt) = os.path.splitext(cur) 
              outTransFileName = fileNameShort + self.xsltTransFileName[self.xsltTransFileName.index("2"):]
              outXMLFileName = fileNameShort + ".xml"
              #
              if not self._processXSLTTrans(self.theories[cur], outTransFileName, outXMLFileName):
                ret = False
                break
          else:
            ret = False           
        else:
          ret = False
        # free resources 
        for cur in self.theories:
          self.theories[cur].freeDoc()
        self.theories.clear()
      else:
        ret = False
    else:
      ret = False
    libxslt.cleanup()
    return ret
  
  def _checkAttributes(self):
    """Check if all necessary attributes have been set.
    
    @return True if succeeded, False otherwise"""
    ret = self.inFile != None and \
      self.xsltInclFileName != None and \
      self.xsltPresFileName != None and \
      self.xsltTransFileName != None and ("2" in self.xsltTransFileName)
      
    if ret == False: self.errorno = OMDocPackageGenerator.OPG_ERR_ATT
    return ret
      
  def _parseAndLoadFile(self, file):
    """Parse and load XML file
    
    @param file The file to load and parse
    @return The XML tree if succeeded, None otherwise"""
    if "~" in file:
       file = file.replace("~", os.path.expanduser("~"))
    try:
      return libxml2.parseFile(file)
    except:
      self.errorno = OMDocPackageGenerator.OPG_ERR_PARSE
      return None
  
  def _getAllTheories(self, doc):
    """Get all theory imports. 
    This method traverses recursively all theory imports.
    Each theory is mapped to its corresponding XML tree.
    Duplicated theory imports are not stored.
    
    @param doc The XML tree to start with the traversion
    @return True if succeeded, otherwise False"""
    ret = True
    context = doc.xpathNewContext()
    if context != None:
      context.xpathRegisterNs("omdoc", "http://www.mathweb.org/omdoc")
      imports = context.xpathEvalExpression("//omdoc:imports")
      new_imports = {}        
      for cur in imports:
        importedTheory = cur.prop("from")
        importedFile = importedTheory[:importedTheory.index("#")]
        if importedFile != None:  
          if os.path.join(self.inPath, importedFile) not in self.theories:
            doc = self._parseAndLoadFile(os.path.join(self.inPath, importedFile))
            if doc != None:
              new_imports[os.path.join(self.inPath, importedFile)] = doc
            else:
              errorno = OMDocPackageGenerator.OPG_ERR_THEORY
              ret = False
              break              
          for cur in new_imports:
            self.theories[cur] = new_imports[cur]        
            ret = self._getAllTheories(self.theories[cur])
        else:
          errorno = OMDocPackageGenerator.OPG_ERR_THEORY
          ret = False 
          break        
      context.xpathFreeContext()
    return ret
    
  def _processXSLTPres(self, doc, outPresFileName):
    """Process the presentation XSLT.
    This method is analog to the following program call
      xsltproc -o <outPresFileName>  <xsltPresFileName> <XML file>
    
    @param doc The XML tree to apply the XSLT to
    @param outPresFileName The output file name
    @return void"""
    ret = True
    presStyle = self._parseAndLoadFile(self.xsltPresFileName)
    if presStyle == None:
      self.errorno = OMDocPackageGenerator.OPG_ERR_XSLT_PRES
      ret = False
    else:
      cur = libxslt.parseStylesheetDoc(presStyle)
      if cur == None:
        presStyle.freeDoc()
        self.errorno = OMDocPackageGenerator.OPG_ERR_XSLT_PRES
        ret = False
      else:
        ret = self._xsltProcess(doc, cur, None, outPresFileName)
        presStyle.freeDoc()
    return ret
        
  def _processXSLTIncl(self, doc, outPresFileName, outInclFileName):
    """Process the inclusion XSLT.
    This method is analog to the following program call
      xsltproc -o <outInclFileName> --stringparam self <outPresFileName> <xsltInclFileName> <XML file>
    
    @param doc The XML tree to apply the XSLT to
    @param outPresFileName The presentation XSLT file name
    @param outInclFileName The output file name
    @return void""" 
    ret = True    
    params = {}
    inclStyle = self._parseAndLoadFile(self.xsltInclFileName)
    if inclStyle == None:
      self.errorno = OMDocPackageGenerator.OPG_ERR_XSLT_INCL
      ret = False
    else:
      cur = libxslt.parseStylesheetDoc(inclStyle)
      if cur == None:
        inclStyle.freeDoc()
        self.errorno = OMDocPackageGenerator.OPG_ERR_XSLT_INCL
        ret = False
      else:
        params["self"] = "'%s'" % (outPresFileName)
        ret = self._xsltProcess(doc, cur, params, outInclFileName)
        inclStyle.freeDoc()
    return ret
        
  def _generateXSLT(self, outInclFileName, outTransFileName):
    """Generate XSLT.
    This method is analog to the following program call
      make2files '<xsltTransFileName>' '<outInclFileName>' > <outTransFileName>
    
    @param outInclFileName
    @param outTransFileName
    @return void"""
    ret = True
    try:
      f = open(outTransFileName, "w")
      f.write("<?xml version='1.0'?>\n")
      f.write("<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>\n") 
      f.write("<!-- we specialize -->\n")
      f.write("<xsl:include href='%s'/>\n" % self.xsltTransFileName)
      f.write("<!-- by the specialized templates contained in this style sheet -->\n")
      f.write("<xsl:include href='%s'/>\n" % outInclFileName)
      f.write("</xsl:stylesheet>")
      f.close()
    except:
      self.errorno = OMDocPackageGenerator.OPG_ERR_XSLT
      ret = False
    return ret
    
  def _processXSLTTrans(self, doc, outTransFileName, outXMLFileName):
    """Process the transformation XSLT.
    This method is analog to the following program call
      xsltproc -o <outXMLFileName>  --stringparam css omdoc-cnx.css <outTransFileName> <XML file>
    
    @param doc The XML tree to apply the XSLT to
    @param outTransFileName
    @param outXMLFileName The output file name
    @return void"""
    ret = True
    params = {}
    transStyle = self._parseAndLoadFile(outTransFileName)
    if transStyle == None:
      self.errorno = OMDocPackageGenerator.OPG_ERR_XSLT_TRANS
      ret = False
    else:
      cur = libxslt.parseStylesheetDoc(transStyle)
      if cur == None:
        transStyle.freeDoc()
        self.errorno = OMDocPackageGenerator.OPG_ERR_XSLT_TRANS
        ret = False
      else:
        params["css"] = "'omdoc-cnx.css'"
        ret = self._xsltProcess(doc, cur, params, outXMLFileName)
        transStyle.freeDoc()
    return ret
        
  def _xsltProcess(self, doc, cur, params, outFile):
    """Process a XSLT.
    
    @param doc The XML tree to apply the XSLT to
    @param cur
    @param params
    @param outFile
    @return void"""
    ret = True
    result = cur.applyStylesheet(doc, params)
    if result == None:
      self.errorno = OMDocPackageGenerator.OPG_ERR_XSLT_PROC
      ret = False
    else:
      if debug == 1:
        res.debugDumpDocument(None)
      try:
        if "~" in outFile:
         outFile = outFile.replace("~", os.path.expanduser("~"))
        if cur.saveResultToFilename(outFile, result, 0) == -1:
          self.errorno = OMDocPackageGenerator.OPG_ERR_XSLT_PROC
          ret = False
      except:
        self.errorno = OMDocPackageGenerator.OPG_ERR_XSLT_PROC
        ret = False
      result.freeDoc()
    return ret
    

def usage():
  """Print how to use this little program."""
  print __doc__  

def main(argv = None):
  """Main entry point in standalone mode"""
  global debug
  debug = False
  recursive = False
  xsltInclFileName = None
  xsltPresFileName = None
  xsltTransFileName = None
  xmlCatalog = None
  # check arguments
  if not argv:
      argv = sys.argv[1:]
      if len(argv) <= 0:
          usage()
          sys.exit(1)   
  # extract program arguments        
  try:
    opts, args = \
      getopt.getopt(argv, \
                    "hi:p:t:rc:d", ["help", "include=", "presentation=", "transformation=", "recursive", "catalog"])
  except getopt.GetoptError:
    usage()
    sys.exit(1)   
  # process programm arguments
  for opt, arg in opts:
    if opt == '-d':
      debug = True
    elif opt in ("-h", "--help"):
      usage()
      sys.exit()
    elif opt in ("-i", "--include"):
      xsltInclFileName = arg
    elif opt in ("-p", "--presentation"):
      xsltPresFileName = arg
    elif opt in ("-t", "--transformation"):
      xsltTransFileName = arg
    elif opt in ("-r", "--recursive"):
      recursive = True
    elif opt in ("-c", "--catalog"):
      xmlCatalog = arg
  # build OMDoc package
  opg = OMDocPackageGenerator()
  
  opg.setXSLTInclFile(xsltInclFileName)
  opg.setXSLTPresFile(xsltPresFileName)
  opg.setXSLTTransFile(xsltTransFileName)
  opg.setXMLCatalog(xmlCatalog)
  opg.setInputFile(args[len(args) - 1], recursive)  
  
  if opg.build():
    print "Done"
  else:
    print "Failed: %i" % opg.getLastError()
      
  
if __name__ == "__main__":
  main()
  sys.exit(0)

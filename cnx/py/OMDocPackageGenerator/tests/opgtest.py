"""Unit test for opg.py"""

import sys
script_dir = sys.path[0]
if script_dir:
  main_dir = '/'.join(script_dir.split('/')[:-1])
  sys.path.insert(0,main_dir)
from opg import OMDocPackageGenerator
import unittest


class BuildCheck(unittest.TestCase):
  def testBuildNoArgs(self):
    """Should fail, cause no arguments are given"""
    opg = OMDocPackageGenerator()
    self.assertFalse(opg.build())
    self.assertTrue(opg.getLastError() == OMDocPackageGenerator.OPG_ERR_ATT)
    
  def testBuildPartilaArgs(self):
    """Should fail, cause not all arguments have been set"""
    opg = OMDocPackageGenerator()
    opg.setXSLTInclFile("~/omdoc/xsl/exincl.xsl")
    opg.setXSLTPresFile("~/omdoc/xsl/expres.xsl")
    self.assertFalse(opg.build())
    self.assertTrue(opg.getLastError() == OMDocPackageGenerator.OPG_ERR_ATT)
    
  def testBuildWrongArgs1(self):
    """Should fail, cause wrong arguments have been set"""
    opg = OMDocPackageGenerator()
    opg.setXSLTInclFile("~/omdoc/xsl/doesnotexist.xsl")
    opg.setXSLTPresFile("~/omdoc/xsl/doesnotexist.xsl")
    opg.setXSLTTransFile("~/omdoc/xsl/does2notexist.xsl") # <--- With 2
    opg.setXMLCatalog("~/omdoc/xsl/doesnotexist.xsl")
    opg.setInputFile("~/omdoc/xsl/doesnotexist.xsl", False)
    self.assertFalse(opg.build())
    self.assertTrue(opg.getLastError() == OMDocPackageGenerator.OPG_ERR_PARSE)
    
  def testBuildWrongArgs2(self):
    """Should fail, cause wrong arguments have been set"""
    opg = OMDocPackageGenerator()
    opg.setXSLTInclFile("~/omdoc/xsl/doesnotexist.xsl")
    opg.setXSLTPresFile("~/omdoc/xsl/doesnotexist.xsl")
    opg.setXSLTTransFile("~/omdoc/xsl/doesnotexist.xsl") # <--- Without 2
    opg.setInputFile("~/omdoc/xsl/doesnotexist.xsl", False)
    self.assertFalse(opg.build())
    self.assertTrue(opg.getLastError() == OMDocPackageGenerator.OPG_ERR_ATT)
    
  #def testBuildNoRecDepNoExists(self):
  #  """..."""
  #  self.assertFalse(opg.build())
    
  #def testBuildNoRecDepExists(self):
  #  """..."""
  #  self.assertTrue(opg.build())
  
  def testBuildNoRec(self):
    """..."""
    opg = OMDocPackageGenerator()
    opg.setXSLTInclFile("~/omdoc/xsl/exincl.xsl")
    opg.setXSLTPresFile("~/omdoc/xsl/expres.xsl")
    opg.setXSLTTransFile("~/omdoc/xsl/omdoc2pmml.xsl")
    opg.setXMLCatalog("~/omdoc/lib/omdoc.cat")
    opg.setInputFile("~/omdoc/examples/omstd/arith1.omdoc", False)
    self.assertTrue(opg.build())
    
  def testBuildRec(self):
    """..."""
    opg = OMDocPackageGenerator()
    opg.setXSLTInclFile("~/omdoc/xsl/exincl.xsl")
    opg.setXSLTPresFile("~/omdoc/xsl/expres.xsl")
    opg.setXSLTTransFile("~/omdoc/xsl/omdoc2pmml.xsl")
    opg.setXMLCatalog("~/omdoc/lib/omdoc.cat")
    opg.setInputFile("~/omdoc/examples/omstd/arith1.omdoc", True)
    self.assertTrue(opg.build())
  
  
if __name__ == "__main__":
  unittest.main()
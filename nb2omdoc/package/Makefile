

.PHONY:  package tar clean


DOTM = nb2omdoc.m
CODE = nb2omsrc.m
USGE = usage.txt
TGZ  = nb2om.tgz
BCAT = BrowserCategories.m
BROW = NB2OMDHelp.nb
INST = /home/sutner/.Mathematica/Applications


$(DOTM):	$(CODE)
		@cat pack-header > $(DOTM)
		@cat $(USGE) >> $(DOTM)
		@cat pack-private >> $(DOTM)
		@cat $(CODE) >> $(DOTM)
		@cat pack-footer >> $(DOTM)



package:	$(DOTM) $(BCAT) $(BROW)
		@cp $(DOTM) nb2omdoc
		@cp $(BCAT) $(BROW) nb2omdoc/Documentation/English

tar:		package README
		@cp README nb2omdoc
		@tar zcf $(TGZ) nb2omdoc 

install:	tar
		@cp $(TGZ) $(INST)
		@cd $(INST); rm -f -R nb2omdoc; tar zxf $(TGZ); rm -f $(TGZ)

clean:
		@rm -f $(DOTM) *~ 

allclean:
		@rm -f $(DOTM) $(TGZ) *~ 






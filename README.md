# HD_laboratory
Code for labs for HD class

## Issues fro ETL
* Dates are showing completely wrong in the views
* I cannot do the Analysis Services block in SSIS for some reason?

## Issues for lab4 (HD implementation)
* The DD dimension for Postepowanie is created but disconnected cause it caused an error
* No idea how correct the n-n relations are
* No idea of the sql DB is actually correct for the lab requirements

## Issues for insert generation
* The dates are randomly chosen for every table so sometimes they make no sense in reality (ex. zdarzenie happening after postepowanie is done)
* Cost of Naprawy + Platnosc won't add up to cost of Odszkodowanie cause they are all just randomly generated
* Names in excel are generated seperately from sql, so there is a big chance they just wont match
* the excel is not full for now, cause i don't think we have to do anything with it rn and that would end up being like 5mln rows in each file

* __We NEED to add some leaving dates for workers (not all though? ig) beacasue we need them for later labs (make sure the table name matches whatever was written in Lab3 project)__





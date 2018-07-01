#! /usr/bin/env python2.7
"""
This is a script to create data for toy "problem" for professor
Uses values in params.json  (professor uses params.dat)

"""

import random
import ROOT 
import json
from numpy.random import poisson
from sympy import symbols

myfile = open("params.json","r");

myjson = json.load(myfile)
print "myjson object: ",myjson

params = myjson["params"]
print "params object: ",params

a = params["a"]
b = params["b"]
c = params["c"]

x, y, z = symbols('x y z')
func1 = 100*(400.-c*100.*pow(abs(x-5.0*b)/10.0,2+a))
print 'func1: ',func1


def eval3_1(xx,yy,zz):
    v = func1.subs(x,xx)
    print "func1: ",func1,'xx=',xx,' v=',v
    return v

ROOT.TH1.SetDefaultSumw2()
nbins=50
xmin=0.0
xmax=20.0
h1 = ROOT.TH1D( 'h1_foo1', 'toy data', nbins, xmin, xmax )
# for b in range(1,h1.GetNbinsX()+1):
for b in range(h1.GetNbinsX()):
    xmid = h1.GetBinLowEdge(b+1) + 0.5*h1.GetBinWidth(b+1)
    n = eval3_1(xmid,0,0)
    if (n<=0):
        continue
    # mean for this bin ... now poisson
    nthrows = poisson(n)
    print b, n, nthrows
    for toss in range(nthrows):
        h1.Fill(xmid)


ofile = ROOT.TFile( "hists.root", "RECREATE" )
h1.Write()
ofile.Close()

# end-of-script

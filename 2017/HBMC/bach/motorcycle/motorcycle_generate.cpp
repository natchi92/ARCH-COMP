#include <iostream>
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <fstream>
#include <vector>

using namespace std;

ofstream *out;

void print(string str)
{
    (*out)<<str<<endl;
}

string to_string(int i){
  char chr[256];
  string str;
  sprintf(chr,"%i",i);
  str=chr;
  return str;
}

int main()
{
    int N;
    char c;
    char p[2]={'r','u'};
    for(N=2;N<=20;N++){
        for(int index=0;index<2;index++){
                c=p[index];
    string base="C:\\Users\\hp\\Documents\\case\\motorcycle";
    string s = "";
    //cin>>N>>c;
    if(c == 'r'){
        s = "\t\t\t<assignment>t:=0</assignment>\n";
        base+="\\reachable";
    }
    else{
        base+="\\unreachable";
    }
    out=new ofstream(base+"\\motorcycle_"+to_string(N)+".xml");
    print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<sspaceex xmlns=\"http://www-verimag.imag.fr/xml-namespaces/sspaceex\" version=\"0.2\" math=\"SpaceEx\">");
    print("\t<component id=\"moto_template\">\n\t\t<param name=\"x\" type=\"real\" local=\"true\" d1=\"1\" d2=\"1\" dynamics=\"any\" />");
    print("\t\t<param name=\"t\" type=\"real\" local=\"true\" d1=\"1\" d2=\"1\" dynamics=\"any\" />");
    print("\t\t<param name=\"g\" type=\"real\" local=\"true\" d1=\"1\" d2=\"1\" dynamics=\"any\" />");
    print("\t\t<param name=\"go_0\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"go_1\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"close_0\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"close_1\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"not_close_0\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"not_close_1\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"ref\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"rel\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"get_0\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"get_1\" type=\"label\" local=\"false\" />");
    print("\t\t<location id=\"2\" name=\"s1\">\n\t\t\t<flow>x'==0 &amp; t'==1 &amp; g'&gt;=-0.001 &amp; g'&lt;=-0.0001</flow>\n\t\t</location>");
    print("\t\t<location id=\"3\" name=\"s2\">\n\t\t\t<invariant>t&lt;=3</invariant>\n\t\t\t<flow>x'&gt;=0.01 &amp; x'&lt;=0.03 &amp; t'==1 &amp; g'&gt;=-0.5 &amp; g'&lt;=-0.3</flow>\n\t\t</location>");
    print("\t\t<location id=\"4\" name=\"s3\">\n\t\t\t<invariant>x&lt;=100 &amp; g&gt;=100</invariant>\n\t\t\t<flow>x'&gt;=0.02 &amp; x'&lt;=0.04 &amp; t'==1 &amp; g'&gt;=-0.6 &amp; g'&lt;=-0.4</flow>\n\t\t</location>");
    print("\t\t<location id=\"5\" name=\"s4\">\n\t\t\t<invariant>x&lt;=100 &amp; g&gt;=100</invariant>\n\t\t\t<flow>x'&gt;=0.01 &amp; x'&lt;=0.03 &amp; t'==1 &amp; g'&gt;=-0.5 &amp; g'&lt;=-0.3</flow>\n\t\t</location>");
    print("\t\t<location id=\"6\" name=\"s5\">\n\t\t\t<invariant>x&lt;=100 &amp; g&gt;=100</invariant>\n\t\t\t<flow>x'&gt;=0.03 &amp; x'&lt;=0.05 &amp; t'==1 &amp; g'&gt;=-0.7 &amp; g'&lt;=-0.5</flow>\n\t\t</location>");
    print("\t\t<location id=\"7\" name=\"s6\">\n\t\t\t<invariant>g&lt;=12000</invariant>\n\t\t\t<flow>x'==0 &amp; t'==1 &amp; g'&gt;=300 &amp; g'&lt;=500</flow>\n\t\t</location>");
    print("\t\t<location id=\"8\" name=\"s7\">\n\t\t\t<invariant>t&lt;=2</invariant>\n\t\t\t<flow>x'&gt;=0.002 &amp; x'&lt;=0.004 &amp; t'==1 &amp; g'&gt;=-0.06 &amp; g'&lt;=-0.04</flow>\n\t\t</location>");
    print("\t\t<location id=\"9\" name=\"s8\">\n\t\t\t<flow>x'==0 &amp; t'==0 &amp; g'==0</flow>\n\t\t</location>");
    print("\t\t<transition source=\"2\" target=\"3\">\n\t\t\t<label>go_0</label>\n\t\t\t<assignment>t:=0</assignment>\n\t\t</transition>");
    print("\t\t<transition source=\"3\" target=\"4\">\n\t\t\t<label>go_1</label>\n\t\t\t<guard>t==3</guard>\n\t\t</transition>");
    print("\t\t<transition source=\"4\" target=\"5\">\n\t\t\t<label>close_0</label>\n\t\t</transition>");
    print("\t\t<transition source=\"4\" target=\"6\">\n\t\t\t<label>close_1</label>\n\t\t</transition>");
    print("\t\t<transition source=\"4\" target=\"7\">\n\t\t\t<label>ref</label>\n\t\t\t<guard>g==100</guard>\n\t\t</transition>");
    print("\t\t<transition source=\"4\" target=\"8\">\n\t\t\t<label>get_0</label>\n\t\t\t<guard>x==100</guard>\n"+s+"\t\t</transition>");
    print("\t\t<transition source=\"5\" target=\"4\">\n\t\t\t<label>not_close_0</label>\n\t\t</transition>");
    print("\t\t<transition source=\"6\" target=\"4\">\n\t\t\t<label>not_close_1</label>\n\t\t</transition>");
    print("\t\t<transition source=\"7\" target=\"4\">\n\t\t\t<label>rel</label>\n\t\t\t<guard>g==12000</guard>\n\t\t</transition>");
    print("\t\t<transition source=\"8\" target=\"9\">\n\t\t\t<label>get_1</label>\n\t\t\t<guard>t==2</guard>\n\t\t</transition>");
    print("\t</component>");

    string foot="</sspaceex>";

    print("\t<component id=\"system\">");
    for(unsigned i = 0; i <= N; i++)
    {
        string id1 = to_string(i), id2 = to_string(i+1);
        print("\t\t<param name=\"go_"+id1+"_"+id2+"\" type=\"label\" local=\"false\" />");
        print("\t\t<param name=\"get_"+id1+"_"+id2+"\" type=\"label\" local=\"false\" />");
        print("\t\t<param name=\"close_"+id1+"_"+id2+"\" type=\"label\" local=\"false\" />");
        print("\t\t<param name=\"not_close_"+id1+"_"+id2+"\" type=\"label\" local=\"false\" />");
    }
    for(unsigned i = 1; i <= N; i++){
        print("\t\t<param name=\"rel_"+to_string(i)+"\" type=\"label\" local=\"false\" />");
        print("\t\t<param name=\"ref_"+to_string(i)+"\" type=\"label\" local=\"false\" />");
    }

    for(unsigned i = 0; i < N; i++){
        string id1 = to_string(i), id2 = to_string(i+1), id3 = to_string(i+2);
        print("\t\t<bind component=\"moto_template\" as=\"moto"+id2+"\">");
        print("\t\t\t<map key=\"go_0\">go_" + id1 + "_"+id2+"</map>");
        print("\t\t\t<map key=\"go_1\">go_" + id2 + "_"+id3+ "</map>");
        print("\t\t\t<map key=\"close_0\">close_" + id1 + "_"+id2+ "</map>");
        print("\t\t\t<map key=\"close_1\">close_" + id2 + "_"+id3+ "</map>");
        print("\t\t\t<map key=\"get_0\">get_" + id1 + "_"+id2+ "</map>");
        print("\t\t\t<map key=\"get_1\">get_" + id2 + "_"+id3+ "</map>");
        print("\t\t\t<map key=\"not_close_0\">not_close_" + id1 + "_"+id2+ "</map>");
        print("\t\t\t<map key=\"not_close_1\">not_close_" + id2 + "_"+id3+ "</map>");
        print("\t\t\t<map key=\"ref\">ref_" + id2 + "</map>");
        print("\t\t\t<map key=\"rel\">rel_" + id2 + "</map>");
        print("\t\t</bind>");
    }

    print("\t</component>");
    print(foot);
    out->close();
    out=new ofstream(base+"\\motorcycle_"+to_string(N)+".cfg");

    print("# analysis options");
    print("system = \"system\"");
    string init="moto1.x==0&moto1.g==12000&moto1.t==0&loc(moto1)==s1";
    string forbid = "loc(moto1)==s8";
    for(unsigned i = 1; i < N; i++){
        string id = to_string(i + 1);
        init += "&moto" + id + ".x==0";
        init += "&moto" + id + ".g==12000";
        init += "&moto" + id + ".t==0";
        init += "&loc(moto" + id + ")==s1";
        forbid += "&loc(moto" + id + ")==s8";
    }

    print("initially = \""+init+"\"");
    print("forbidden=\""+forbid+"\"");

    print("iter-max = 9");

    print("rel-err = 1.0e-12");
    print("abs-err = 1.0e-13");

    out->close();
        }}
    return 0;
}

#include <iostream>
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <fstream>
#include <sstream>
#include <vector>

using namespace std;

ofstream *out;

void print(string str)
{
    (*out)<<str<<endl;
}



int main()
{
    int N;
    char c;
    string s = "\t\t\t<guard>x&lt;1</guard>\n";
    cin>>N>>c;
    if(c == 'r'){
        s = "";
    }
    out=new ofstream("/home/xiongwen/BACH/case/FDDI/unreachable/FDDI_"+to_string(N)+".xml");
    print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<sspaceex xmlns=\"http://www-verimag.imag.fr/xml-namespaces/sspaceex\" version=\"0.2\" math=\"SpaceEx\">");
    print("\t<component id=\"p_template\">\n\t\t<param name=\"x\" type=\"real\" local=\"true\" d1=\"1\" d2=\"1\" dynamics=\"any\" />");
    print("\t\t<param name=\"y\" type=\"real\" local=\"true\" d1=\"1\" d2=\"1\" dynamics=\"any\" />");
    print("\t\t<param name=\"z\" type=\"real\" local=\"true\" d1=\"1\" d2=\"1\" dynamics=\"any\" />");
    print("\t\t<param name=\"rt_0\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"rt_1\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"tau\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"tt\" type=\"label\" local=\"false\" />");
    print("\t\t<location id=\"1\" name=\"s1\">\n\t\t\t<flow>x'==1 &amp; y'==1 &amp; z'==1</flow>\n\t\t</location>");
    print("\t\t<location id=\"2\" name=\"s2\">\n\t\t\t<flow>x'==1 &amp; y'==1 &amp; z'==1</flow>\n\t\t</location>");
    print("\t\t<location id=\"3\" name=\"s3\">\n\t\t\t<flow>x'==1 &amp; y'==1 &amp; z'==1</flow>\n\t\t</location>");
    print("\t\t<location id=\"4\" name=\"s4\">\n\t\t\t<flow>x'==1 &amp; y'==1 &amp; z'==1</flow>\n\t\t</location>");
    print("\t\t<location id=\"5\" name=\"s5\">\n\t\t\t<flow>x'==1 &amp; y'==1 &amp; z'==1</flow>\n\t\t</location>");
    print("\t\t<location id=\"6\" name=\"s6\">\n\t\t\t<flow>x'==1 &amp; y'==1 &amp; z'==1</flow>\n\t\t</location>");
    print("\t\t<transition source=\"1\" target=\"2\">\n\t\t\t<label>rt_0</label>\n" + s + "\t\t\t<assignment>x:=0</assignment>\n\t\t</transition>");
    print("\t\t<transition source=\"2\" target=\"3\">\n\t\t\t<label>tau</label>\n\t\t\t<guard>x==20&amp;z&lt;620</guard>\n\t\t</transition>");
    print("\t\t<transition source=\"2\" target=\"4\">\n\t\t\t<label>rt_1</label>\n\t\t\t<guard>x==20&amp;z&gt;=620</guard>\n\t\t</transition>");
    print("\t\t<transition source=\"3\" target=\"4\">\n\t\t\t<label>rt_1</label>\n\t\t\t<guard>z&lt;=620</guard>\n\t\t</transition>");
    print("\t\t<transition source=\"4\" target=\"5\">\n\t\t\t<label>tt</label>\n\t\t\t<assignment>x:=0&amp;z:=0</assignment>\n\t\t</transition>");
    print("\t\t<transition source=\"5\" target=\"1\">\n\t\t\t<label>rt_1</label>\n\t\t\t<guard>x==20&amp;z&gt;=620</guard>\n\t\t</transition>");
    print("\t\t<transition source=\"5\" target=\"6\">\n\t\t\t<label>tau</label>\n\t\t\t<guard>x==20&amp;z&lt;62</guard>\n\t\t</transition>");
    print("\t\t<transition source=\"6\" target=\"1\">\n\t\t\t<label>rt_1</label>\n\t\t\t<guard>y&lt;=620</guard>\n\t\t\t<assignment>x:=0</assignment>\n\t\t</transition>");
    print("\t</component>");

    string foot="</sspaceex>";

    print("\t<component id=\"system\">");
    print("\t\t<param name=\"t0\" type=\"label\" local=\"false\" />");
    for(unsigned i = 1; i < N; i++)
    {
        string name = to_string(i);
        print("\t\t<param name=\"rt_"+name+"_"+to_string(i+1)+"\" type=\"label\" local=\"false\" />");
        print("\t\t<param name=\"tau_"+name+"\" type=\"label\" local=\"false\" />");
        print("\t\t<param name=\"tt_"+name+"\" type=\"label\" local=\"false\" />");
    }
    print("\t\t<param name=\"rt_1_1\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"rt_"+to_string(N)+"_"+to_string(N)+"\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"tau_"+to_string(N)+"\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"tt_"+to_string(N)+"\" type=\"label\" local=\"false\" />");

    for(unsigned i = 1; i < N - 1; i++){
        print("\t\t<bind component=\"p_template\" as=\"p"+to_string(i+1)+"\">");
        print("\t\t\t<map key=\"rt_0\">rt_" + to_string(i) + "_"+to_string(i+1)+"</map>");
        print("\t\t\t<map key=\"rt_1\">rt_" + to_string(i+1) + "_"+to_string(i+2)+ "</map>");
        print("\t\t\t<map key=\"tau\">tau_" + to_string(i+1) + "</map>");
        print("\t\t\t<map key=\"tt\">tt_" + to_string(i+1) + "</map>");
        print("\t\t</bind>");
    }

    print("\t\t<bind component=\"p_template\" as=\"p1\">");
    print("\t\t\t<map key=\"rt_0\">rt_1_1</map>");
    print("\t\t\t<map key=\"rt_1\">rt_1_2</map>");
    print("\t\t\t<map key=\"tau\">tau_1</map>");
    print("\t\t\t<map key=\"tt\">tt_1</map>");
    print("\t\t</bind>");

    print("\t\t<bind component=\"p_template\" as=\"p"+to_string(N)+"\">");
    print("\t\t\t<map key=\"rt_0\">rt_" + to_string(N-1) + "_" + to_string(N) + "</map>");
    print("\t\t\t<map key=\"rt_1\">rt_" + to_string(N) + "_" + to_string(N) + "</map>");
    print("\t\t\t<map key=\"tau\">tau_" + to_string(N) + "</map>");
    print("\t\t\t<map key=\"tt\">tt_" + to_string(N) + "</map>");
    print("\t\t</bind>");

    print("\t</component>");
    print(foot);
    out->close();
    out=new ofstream("/home/xiongwen/BACH/case/FDDI/unreachable/FDDI_"+to_string(N)+".cfg");

    print("# analysis options");
    print("system = \"system\"");
    string init="p1.x==0&p1.y==0&p1.z==0&loc(p1)==s1";
    string forbid = "loc(p1)==s4";
    for(unsigned i = 1; i < N; i++){
        string id = to_string(i + 1);
        init += "&p" + id + ".x==0";
        init += "&p" + id + ".y==0";
        init += "&p" + id + ".z==0";
        init += "&loc(p" + id + ")==s1";
        forbid += "&loc(p" + id + ")==s4";
    }

    print("initially = \""+init+"\"");
    print("forbidden=\""+forbid+"\"");

    print("iter-max = " + to_string(5));

    print("rel-err = 1.0e-12");
    print("abs-err = 1.0e-13");

    out->close();
    return 0;
}

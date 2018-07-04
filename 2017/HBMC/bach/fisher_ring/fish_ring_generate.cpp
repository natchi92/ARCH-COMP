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
    string base="C:\\Users\\hp\\Documents\\case\\fisher_ring";

    string s = "0";
    //cin>>N>>c;
    if(c == 'r'){
        s = "10000";
        base+="\\reachable";
    }
    else{
        base+="\\unreachable";
    }
    out=new ofstream(base+"\\fisher_ring_"+to_string(N)+".xml");
    print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<sspaceex xmlns=\"http://www-verimag.imag.fr/xml-namespaces/sspaceex\" version=\"0.2\" math=\"SpaceEx\">");
    print("\t<component id=\"process_template\">\n\t\t<param name=\"x\" type=\"real\" local=\"true\" d1=\"1\" d2=\"1\" dynamics=\"any\" />");
    print("\t\t<param name=\"test1_0\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"set1_1\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"test1_1\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"test1_not_1\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"set1_0\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"test0_0\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"set0_1\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"test0_1\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"test0_not_1\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"set0_0\" type=\"label\" local=\"false\" />");
    print("\t\t<location id=\"2\" name=\"s1\">\n\t\t\t<flow>x'&gt;=1.1 &amp; x'&lt;=2.3</flow>\n\t\t</location>");
    print("\t\t<location id=\"3\" name=\"s2\">\n\t\t\t<invariant>x&lt;"+s+"</invariant>\n\t\t\t<flow>x'&gt;=1.1 &amp; x'&lt;=2.3</flow>\n\t\t</location>");
    print("\t\t<location id=\"4\" name=\"s3\">\n\t\t\t<flow>x'&gt;=1.1 &amp; x'&lt;=2.3</flow>\n\t\t</location>");
    print("\t\t<location id=\"5\" name=\"s4\">\n\t\t\t<flow>x'&gt;=1.1 &amp; x'&lt;=2.3</flow>\n\t\t</location>");
    print("\t\t<location id=\"6\" name=\"s5\">\n\t\t\t<flow>x'&gt;=1.1 &amp; x'&lt;=2.3</flow>\n\t\t</location>");
    print("\t\t<location id=\"7\" name=\"s6\">\n\t\t\t<invariant>x&lt;"+s+"</invariant>\n\t\t\t<flow>x'&gt;=1.1 &amp; x'&lt;=2.3</flow>\n\t\t</location>");
    print("\t\t<location id=\"8\" name=\"s7\">\n\t\t\t<flow>x'&gt;=1.1 &amp; x'&lt;=2.3</flow>\n\t\t</location>");
    print("\t\t<location id=\"9\" name=\"s8\">\n\t\t\t<flow>x'&gt;=1.1 &amp; x'&lt;=2.3</flow>\n\t\t</location>");
    print("\t\t<transition source=\"2\" target=\"3\">\n\t\t\t<label>test1_0</label>\n\t\t\t<assignment>x:=0</assignment>\n\t\t</transition>");
    print("\t\t<transition source=\"3\" target=\"4\">\n\t\t\t<label>set1_1</label>\n\t\t\t<assignment>x:=0</assignment>\n\t\t</transition>");
    print("\t\t<transition source=\"4\" target=\"5\">\n\t\t\t<label>test1_1</label>\n\t\t\t<guard>x&gt;3</guard>\n\t\t</transition>");
    print("\t\t<transition source=\"4\" target=\"2\">\n\t\t\t<label>test1_not_1</label>\n\t\t\t<guard>x&gt;3</guard>\n\t\t</transition>");
    print("\t\t<transition source=\"5\" target=\"6\">\n\t\t\t<label>set1_0</label>\n\t\t</transition>");
    print("\t\t<transition source=\"6\" target=\"7\">\n\t\t\t<label>test0_0</label>\n\t\t\t<assignment>x:=0</assignment>\n\t\t</transition>");
    print("\t\t<transition source=\"7\" target=\"8\">\n\t\t\t<label>set0_1</label>\n\t\t\t<assignment>x:=0</assignment>\n\t\t</transition>");
    print("\t\t<transition source=\"8\" target=\"9\">\n\t\t\t<label>test0_1</label>\n\t\t\t<guard>x&gt;3</guard>\n\t\t</transition>");
    print("\t\t<transition source=\"8\" target=\"6\">\n\t\t\t<label>test0_not_1</label>\n\t\t\t<guard>x&gt;3</guard>\n\t\t</transition>");
    print("\t\t<transition source=\"9\" target=\"2\">\n\t\t\t<label>set0_0</label>\n\t\t</transition>");

    print("\t</component>");

    string foot="</sspaceex>";

    print("\t<component id=\"sv_template\">");
    print("\t\t<param name=\"target\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"x\" type=\"real\" local=\"true\" d1=\"1\" d2=\"1\" dynamics=\"any\" />");
    for(unsigned i = 0; i < N; i++){
        string id = to_string(i+1);
        print("\t\t<param name=\"set_0_"+id+"\" type=\"label\" local=\"false\" />");
        print("\t\t<param name=\"set_"+id+"_"+id+"\" type=\"label\" local=\"false\" />");
        print("\t\t<param name=\"test_0_"+id+"\" type=\"label\" local=\"false\" />");
        print("\t\t<param name=\"test_"+id+"_"+id+"\" type=\"label\" local=\"false\" />");
        print("\t\t<param name=\"test_not_"+id+"_"+id+"\" type=\"label\" local=\"false\" />");
    }
    print("\t\t<location id=\""+to_string(N+3)+"\" name=\"st\">\n\t\t\t<flow>x'==0</flow>\n\t\t</location>");
    for(unsigned i = 0; i <= N; i++){
        print("\t\t<location id=\""+to_string(i+2)+"\" name=\"s"+to_string(i)+"\">\n\t\t\t<flow>x'==0</flow>\n\t\t</location>");
    }
    for(unsigned i = 1; i <= N; i++){
        print("\t\t<transition source=\"2\" target=\"2\">\n\t\t\t<label>set_0_"+to_string(i)+"</label>\n\t\t</transition>");
        print("\t\t<transition source=\"2\" target=\"2\">\n\t\t\t<label>test_0_"+to_string(i)+"</label>\n\t\t</transition>");
        print("\t\t<transition source=\"2\" target=\""+to_string(i+2)+"\">\n\t\t\t<label>set_"+to_string(i)+"_"+to_string(i)+"</label>\n\t\t</transition>");
    }
    for(unsigned i = 1; i <= N; i++){
        for(unsigned j = 1; j <= N; j++){
            if(i == j){
                print("\t\t<transition source=\""+to_string(i+2)+"\" target=\""+to_string(i+2)+"\">\n\t\t\t<label>test_"+to_string(i)+"_"+to_string(i)+"</label>\n\t\t</transition>");
            }
            else{
                print("\t\t<transition source=\""+to_string(i+2)+"\" target=\""+to_string(i+2)+"\">\n\t\t\t<label>test_not_"+to_string(j)+"_"+to_string(j)+"</label>\n\t\t</transition>");
                print("\t\t<transition source=\""+to_string(i+2)+"\" target=\""+to_string(j+2)+"\">\n\t\t\t<label>set_"+to_string(j)+"_"+to_string(j)+"</label>\n\t\t</transition>");
            }
        }
        print("\t\t<transition source=\""+to_string(i+2)+"\" target=\"2\">\n\t\t\t<label>set_0_"+to_string(i)+"</label>\n\t\t</transition>");
    }
    for(unsigned i = 3; i <= N + 2; i++){
        print("\t\t<transition source=\""+to_string(i)+"\" target=\""+to_string(N+3)+"\">\n\t\t\t<label>target</label>\n\t\t</transition>");
    }
    print("\t</component>");

    print("\t<component id=\"system\">");
    for(unsigned i = 1; i <= N; i++){
        print("\t\t<param name=\"target"+to_string(i)+"\" type=\"label\" local=\"false\" />");
        for(unsigned j = 1; j <= N; j++){
            print("\t\t<param name=\"set"+to_string(i)+"_0_"+to_string(j)+"\" type=\"label\" local=\"false\" />");
            print("\t\t<param name=\"set"+to_string(i)+"_"+to_string(j)+"_"+to_string(j)+"\" type=\"label\" local=\"false\" />");
            print("\t\t<param name=\"test"+to_string(i)+"_0_"+to_string(j)+"\" type=\"label\" local=\"false\" />");
            print("\t\t<param name=\"test"+to_string(i)+"_"+to_string(j)+"_"+to_string(j)+"\" type=\"label\" local=\"false\" />");
            print("\t\t<param name=\"test"+to_string(i)+"_not_"+to_string(i)+"_"+to_string(i)+"\" type=\"label\" local=\"false\" />");
        }
    }

    for(unsigned i = 1; i <= N; i++){
        string id1 = to_string(i), id2 = to_string((i-1)==0?N:i-1);
        print("\t\t<bind component=\"process_template\" as=\"process"+id1+"\">");
        print("\t\t\t<map key=\"set0_0\">set"+id1+"_0_2</map>");
        print("\t\t\t<map key=\"set0_1\">set" + id1 + "_2_2</map>");
        print("\t\t\t<map key=\"test0_0\">test" + id1 + "_0_2</map>");
        print("\t\t\t<map key=\"test0_1\">test" + id1 + "_2_2</map>");
        print("\t\t\t<map key=\"test0_not_1\">test"+id1+"_not_1_1</map>");
        print("\t\t\t<map key=\"set1_0\">set" + id2 + "_0_1</map>");
        print("\t\t\t<map key=\"set1_1\">set" + id2 + "_1_1</map>");
        print("\t\t\t<map key=\"test1_0\">test" + id2 + "_0_1</map>");
        print("\t\t\t<map key=\"test1_1\">test" + id2 + "_1_1</map>");
        print("\t\t\t<map key=\"test1_not_1\">test"+id2+"_not_2_2</map>");
        print("\t\t</bind>");
    }
    for(unsigned i = 1; i <= N; i++){
        print("\t\t<bind component=\"sv_template\" as=\"sv"+to_string(i)+"\">");
        print("\t\t\t<map key=\"target\">target"+to_string(i)+"</map>");
        string id = to_string(i);
        for(unsigned j = 1; j <= N; j++){
            print("\t\t\t<map key=\"set_0_"+to_string(j)+"\">set" + id + "_0_"+to_string(j)+"</map>");
            print("\t\t\t<map key=\"set_"+to_string(j)+"_"+to_string(j)+"\">set"+id+"_" + to_string(j)+"_"+to_string(j) + "</map>");
            print("\t\t\t<map key=\"test_0_"+to_string(j)+"\">test" + id + "_0_"+to_string(j)+"</map>");
            print("\t\t\t<map key=\"test_"+to_string(j)+"_"+to_string(j)+"\">test"+id+"_" + to_string(j) + "_"+to_string(j)+"</map>");
            print("\t\t\t<map key=\"test_not_1\">test"+id+"_not_"+to_string(j)+"_"+to_string(j)+"</map>");
        }
        print("\t\t</bind>");
    }

    print("\t</component>");
    print(foot);
    out->close();
    out=new ofstream(base+"\\fisher_ring_"+to_string(N)+".cfg");

    print("# analysis options");
    print("system = \"system\"");
    string init="process1.x==0&sv1.x==0&loc(process1)==s1&loc(sv1)==s0";
    string forbid = "loc(process1)==s8&loc(sv)==st";
    for(unsigned i = 1; i < N; i++){
        string id = to_string(i + 1);
        init += "&process" + id + ".x==0";
        init += "&sv" + id + ".x==0";
        init += "&loc(process" + id + ")==s1";
        init += "&loc(sv" + id + ")==s0";
        forbid += "&loc(process" + id + ")==s8";
        forbid += "&loc(sv" + id + ")==st";
    }

    print("initially = \""+init+"\"");
    print("forbidden=\""+forbid+"\"");

    print("iter-max = 9");

    print("rel-err = 1.0e-12");
    print("abs-err = 1.0e-13");

    out->close();
        }
    }
    return 0;
}

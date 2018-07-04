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
    string base="C:\\Users\\hp\\Documents\\case\\fisher_star";
    string s = "1";
    //cin>>N>>c;
    if(c == 'r'){
        s = "10000";
        base+="\\reachable";
    }
    else{
        base+="\\unreachable";
    }
    out=new ofstream(base+"\\fisher_star_"+to_string(N)+".xml");
    print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<sspaceex xmlns=\"http://www-verimag.imag.fr/xml-namespaces/sspaceex\" version=\"0.2\" math=\"SpaceEx\">");
    print("\t<component id=\"process_template\">\n\t\t<param name=\"x\" type=\"real\" local=\"true\" d1=\"1\" d2=\"1\" dynamics=\"any\" />");
    print("\t\t<param name=\"set_0\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"set_1\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"test_0\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"test_1\" type=\"label\" local=\"false\" />");
    print("\t\t<param name=\"test_not_1\" type=\"label\" local=\"false\" />");
    print("\t\t<location id=\"2\" name=\"s1\">\n\t\t\t<flow>x'&gt;=1.1 &amp; x'&lt;=2.3</flow>\n\t\t</location>");
    print("\t\t<location id=\"3\" name=\"s2\">\n\t\t\t<invariant>x&lt;="+s+"</invariant>\n\t\t\t<flow>x'&gt;=1.1 &amp; x'&lt;=2.3</flow>\n\t\t</location>");
    print("\t\t<location id=\"4\" name=\"s3\">\n\t\t\t<flow>x'&gt;=1.1 &amp; x'&lt;=2.3</flow>\n\t\t</location>");
    print("\t\t<location id=\"5\" name=\"s4\">\n\t\t\t<flow>x'&gt;=1.1 &amp; x'&lt;=2.3</flow>\n\t\t</location>");
    print("\t\t<transition source=\"2\" target=\"3\">\n\t\t\t<label>test_0</label>\n\t\t\t<assignment>x:=0</assignment>\n\t\t</transition>");
    print("\t\t<transition source=\"3\" target=\"4\">\n\t\t\t<label>set_1</label>\n\t\t\t<assignment>x:=0</assignment>\n\t\t</transition>");
    print("\t\t<transition source=\"4\" target=\"5\">\n\t\t\t<label>test_1</label>\n\t\t\t<guard>x&gt;3</guard>\n\t\t</transition>");
    print("\t\t<transition source=\"4\" target=\"2\">\n\t\t\t<label>test_not_1</label>\n\t\t\t<guard>x&gt;3</guard>\n\t\t</transition>");
    print("\t\t<transition source=\"5\" target=\"2\">\n\t\t\t<label>set_0</label>\n\t\t</transition>");
    print("\t</component>");

    string foot="</sspaceex>";

    print("\t<component id=\"sv_template\">");
    print("\t\t<param name=\"x\" type=\"real\" local=\"true\" d1=\"1\" d2=\"1\" dynamics=\"any\" />");
    for(unsigned i = 0; i < N; i++){
        string id = to_string(i+1);
        print("\t\t<param name=\"set_0_"+id+"\" type=\"label\" local=\"false\" />");
        print("\t\t<param name=\"set_"+id+"_"+id+"\" type=\"label\" local=\"false\" />");
        print("\t\t<param name=\"test_0_"+id+"\" type=\"label\" local=\"false\" />");
        print("\t\t<param name=\"test_"+id+"_"+id+"\" type=\"label\" local=\"false\" />");
        print("\t\t<param name=\"test_not_"+id+"_"+id+"\" type=\"label\" local=\"false\" />");
    }
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
    print("\t</component>");

    print("\t<component id=\"system\">");
    for(unsigned i = 1; i <= N; i++)
    {
        print("\t\t<param name=\"set_0_"+to_string(i)+"\" type=\"label\" local=\"false\" />");
        print("\t\t<param name=\"set_"+to_string(i)+"_"+to_string(i)+"\" type=\"label\" local=\"false\" />");
        print("\t\t<param name=\"test_0_"+to_string(i)+"\" type=\"label\" local=\"false\" />");
        print("\t\t<param name=\"test_"+to_string(i)+"_"+to_string(i)+"\" type=\"label\" local=\"false\" />");
        print("\t\t<param name=\"test_not_"+to_string(i)+"_"+to_string(i)+"\" type=\"label\" local=\"false\" />");
    }

    for(unsigned i = 1; i <= N; i++){
        string id1 = to_string(i), id2 = to_string(i+1), id3 = to_string(i+2);
        print("\t\t<bind component=\"process_template\" as=\"process"+id1+"\">");
        print("\t\t\t<map key=\"set_0\">set_0_" + id1 + "</map>");
        print("\t\t\t<map key=\"set_1\">set_" + id1 + "_"+id1+ "</map>");
        print("\t\t\t<map key=\"test_0\">test_0_" + id1 + "</map>");
        print("\t\t\t<map key=\"test_1\">test_" + id1 + "_"+id1+ "</map>");
        print("\t\t\t<map key=\"test_not_1\">test_not_" + id1 + "_"+id1+ "</map>");
        print("\t\t</bind>");
    }
    print("\t\t<bind component=\"sv_template\" as=\"sv\">");
    for(unsigned i = 1; i <= N; i++){
        string id = to_string(i);
        print("\t\t\t<map key=\"set_0_"+id+"\">set_0_" + id + "</map>");
        print("\t\t\t<map key=\"set_"+id+"_"+id+"\">set_"+id+"_" + id + "</map>");
        print("\t\t\t<map key=\"test_0_"+id+"\">test_0_" + id + "</map>");
        print("\t\t\t<map key=\"test_"+id+"_"+id+"\">test_"+id+"_" + id + "</map>");
        print("\t\t\t<map key=\"test_not_"+id+"_"+id+"\">test_not_"+id+"_" + id + "</map>");
    }
    print("\t\t</bind>");

    print("\t</component>");
    print(foot);
    out->close();
    out=new ofstream(base+"\\fisher_star_"+to_string(N)+".cfg");

    print("# analysis options");
    print("system = \"system\"");
    string init="process1.x==0&sv.x==0&loc(process1)==s1&loc(sv)==s0";
    string forbid = "loc(process1)==s4&loc(sv)==s"+to_string(N);
    for(unsigned i = 1; i < N; i++){
        string id = to_string(i + 1);
        init += "&process" + id + ".x==0";
        init += "&loc(process" + id + ")==s1";
        forbid += "&loc(process" + id + ")==s4";
    }

    print("initially = \""+init+"\"");
    print("forbidden=\""+forbid+"\"");

    print("iter-max = "+to_string(3 * N + 1));

    print("rel-err = 1.0e-12");
    print("abs-err = 1.0e-13");

    out->close();
        }}
    return 0;
}

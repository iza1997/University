#include <iostream>
#include <vector>
using namespace std;

struct node {
	int parent;

  int dfs_in;
  int dfs_out;

	int next;
	int prev;

  int firstChild;

	node()
	{
	  parent = -1;
	  next = -1;
	  prev = -1;
	  firstChild = -1;
	  dfs_in = -1;
	  dfs_out= -1;
	  
	}

	int getId(node* tab) const
	{
	  return (this-tab) + 1;
	}
	
	void addChild(int id, node* tab)
	{
	  node& child = tab[id-1];
	  
	  child.parent = getId(tab);
	  
	  if (firstChild != -1)
	    tab[firstChild-1].prev = id;
	    
	  child.next = firstChild;
	  firstChild = id;
	}
};


void dfs(node* tab)
{
  int c = 0;
  \
  node* cur = tab;
  while(cur != nullptr)
  {
    if (cur->dfs_in == -1)
      cur->dfs_in = c;
      
    
    // go deeper
    if (cur->firstChild != -1 && tab[cur->firstChild - 1].dfs_out == -1)
    {
      cur = &tab[cur->firstChild - 1];
      c++;
    }
    else if (cur->next != -1)
    {
      cur->dfs_out = c;

      // take next child
      cur = &tab[cur->next-1];
      c++;
    }
    else
    {
      cur->dfs_out = c;

      // go up
      if (cur->parent != -1)
      {
        cur = &tab[cur->parent-1];
      }
      else
      {
        // the end
        cur = nullptr;
      }
    }
    
  }
}

int main() {
	int lkobiet;
	int lzapytan;
	cin >> lkobiet >> lzapytan;
	node graf[lkobiet];
	int odp[lzapytan];

	int a;
	int b;
	int i;

	int next_branch = 1;
	for (int i = 1; i < (lkobiet); i++) {
		cin >> a;

    graf[a-1].addChild(i+1, graf);
	}
  
  dfs(graf);

	for (int i = 0; i < lzapytan; i++) {
		cin >> a >> b;

		if (a == 1) {
			odp[i] = 1;
		} else {

		  odp[i] = 0;
		  
		  if (graf[a-1].dfs_in < graf[b-1].dfs_in && graf[a-1].dfs_out >= graf[b-1].dfs_in)
		  {
		    odp[i] = 1;
		  }
		}
	}

	for (int i = 0; i < lzapytan; i++) {
		if (odp[i] == 1) {
			cout << "TAK" << endl;
		} else {
			cout << "NIE" << endl;
		}
  }
}
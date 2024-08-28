using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace DBMSApp
{
    public partial class Form1 : Form
    {
        SqlConnection cs = new SqlConnection("Data Source = DESKTOP-00EAF0L;" +
            " Initial Catalog = bookstore; Integrated Security = True");
        SqlDataAdapter da = new SqlDataAdapter();
        BindingSource bsP = new BindingSource();
        BindingSource bsC = new BindingSource();
        DataSet dsP = new DataSet();
        DataSet dsC = new DataSet();
        public Form1()
        {
            InitializeComponent();
        }

        private void buttonConnect_Click(object sender, EventArgs e)
        {
            da.SelectCommand = new SqlCommand("SELECT * FROM Authors", cs);
            dsP.Clear();
            da.Fill(dsP);
            dataGridViewParent.DataSource = dsP.Tables[0];
            bsP.DataSource = dsP.Tables[0];
            bsP.MoveLast();
            
        }

        private void dataGridViewParent_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (dataGridViewParent.Rows[e.RowIndex].Cells[e.ColumnIndex].Value == null)
                return;


            string Id_Author = dataGridViewParent.Rows[e.RowIndex].Cells[0].Value.ToString();


            da.SelectCommand = new SqlCommand("SELECT * from Books " +
                    "where AuthorID = " + Id_Author + "; ", cs);
            dsC.Clear();
            da.Fill(dsC);
            dataGridViewChild.DataSource = dsC.Tables[0];
            bsC.DataSource = dsC.Tables[0];
        }

        private void buttonAdd_Click(object sender, EventArgs e)
        {
            if (dataGridViewParent.SelectedCells.Count == 0)
            {
                MessageBox.Show("Parent line must be selected!");
                return;
            }
            else if(dataGridViewParent.SelectedCells.Count > 1)
            {
                MessageBox.Show("Only one parent line must be selected!");
                return;
            }


            da.InsertCommand = new
                SqlCommand("INSERT INTO Books(Title,AuthorId,Genre)" +
                    " VALUES (@T,@id,@G);", cs);
            da.InsertCommand.Parameters.Add("@id",
                SqlDbType.Int).Value = dsP.Tables[dataGridViewParent.CurrentCell.ColumnIndex].Rows[dataGridViewParent.CurrentCell.RowIndex][0];

            da.InsertCommand.Parameters.Add("@T",
                SqlDbType.VarChar).Value = textBoxTitle.Text;

            da.InsertCommand.Parameters.Add("@G",
                SqlDbType.VarChar).Value = textBoxGenre.Text;

            cs.Open();
            da.InsertCommand.ExecuteNonQuery();
            cs.Close();
            dsC.Clear();
            da.Fill(dsC);
        }

        private void buttonDelete_Click(object sender, EventArgs e)
        {
            if (dataGridViewChild.SelectedCells.Count == 0)
            {
                MessageBox.Show("A child line must be selected!");
                return;
            }
            else if (dataGridViewChild.SelectedCells.Count > 1)
            {
                MessageBox.Show("Only one child line must be selected!");
                return;
            }
            da.DeleteCommand = new SqlCommand("Delete " +
            "from Books where BookID = @id;", cs);

            da.DeleteCommand.Parameters.Add("@id",
                SqlDbType.Int).Value = dsC.Tables[0].Rows[dataGridViewChild.CurrentCell.RowIndex][0];

            cs.Open();
            da.DeleteCommand.ExecuteNonQuery();
            cs.Close();
            dsC.Clear();
            da.Fill(dsC);
        }
        private void buttonUpdate_Click(object sender, EventArgs e)
        {
            if (dataGridViewChild.SelectedCells.Count == 0)
            {
                MessageBox.Show("A child line must be selected!");
                return;
            }
            else if (dataGridViewChild.SelectedCells.Count > 1)
            {
                MessageBox.Show("Only one child line must be selected!");
                return;
            }

            int x;
            da.UpdateCommand = new SqlCommand("Update " +
                "Books set Title = @T, Genre = @G" +
                " where BookID=@id", cs);

            da.UpdateCommand.Parameters.Add("@id",
                SqlDbType.Int).Value = dsC.Tables[0].Rows[dataGridViewChild.CurrentCell.RowIndex][0];

            da.UpdateCommand.Parameters.Add("@T",
                SqlDbType.VarChar).Value = textBoxTitle.Text;

            da.UpdateCommand.Parameters.Add("@G",
                SqlDbType.VarChar).Value = textBoxGenre.Text;


            cs.Open();
            x = da.UpdateCommand.ExecuteNonQuery();
            cs.Close();
            dsC.Clear();
            da.Fill(dsC);

            if (x >= 1)
                MessageBox.Show("The record has been updated");
        }
    }
}
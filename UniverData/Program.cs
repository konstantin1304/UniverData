using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Common;
using System.Data.SqlClient;

namespace UniverData
{
    class Program
    {
        static void Main(string[] args)
        {
            IDbConnection connection = new SqlConnection(new SqlConnectionStringBuilder
            {
                DataSource = "127.0.0.1",
                InitialCatalog = "University_DNU",
                UserID = "sa",
                Password = "11110000",
                IntegratedSecurity = false
            }.ConnectionString);
            try
            {
                connection.Open();
                IDbCommand command = connection.CreateCommand();
                //command.CommandText = "INSERT INTO EnterpriceDir (Name, Surename, Department, Position) Values ('Vasya', 'Pupkin', 'Development', 'Developer')";
                //command.ExecuteNonQuery();
                //command.CommandText = "INSERT INTO EnterpriceDir (Name, Surename, Department, Position) Values ('Petya', 'Ivanov', 'Cleaning', 'Cleaner')";
                //command.ExecuteNonQuery();
                //command.CommandText = "SELECT ClassroomNumber, Capacity, [Floor] FROM tbClassroom";
                //SELECT Id, SubjId, SpecId FROM tbTeachSubj WHERE Id = 1; --TeachSubjId
                //SELECT Id, ClassroomNumber FROM tbClassroom Where Id = 1; --ClassroomId
                //SELECT Id, PairNumber FROM tbPairTimetable Where Id = 1; --PairTimeTableId  
                //SELECT Id, [Name] FROM tbSubjects WHERE Id = 1; --SubjId
                //SELECT Id, FirstName, LastName From tbTeachers Where Id = 1; --TeachId
                //SELECT Id, [Name] FROM tbSpec WHERE Id = 1; --SpecId
                //SELECT Id, ClassroomId, TeachSubjId, PairTimetableId FROM tbTimetable;

                List<int[]> ids = new List<int[]>();


                command.CommandText = "SELECT ClassroomId, TeachSubjId, PairTimetableId FROM tbTimetable;";
                using (IDataReader reader = command.ExecuteReader())
                    while (reader.Read())
                    {
                        ids.Add(new int[] { reader.GetInt32(0), reader.GetInt32(1), reader.GetInt32(2) });
                    }

                foreach (var idsArr in ids)
                {
                    var ClassroomId = idsArr[0];
                    var TeachSubjId = idsArr[1];
                    var PairTimetableId = idsArr[2];
                    command = connection.CreateCommand();
                    command.CommandText = "SELECT SubjId, SpecId, TeachId FROM tbTeachSubj WHERE Id=" + TeachSubjId + ";";
                    var reader = command.ExecuteReader();

                    var SubjId = reader.GetInt32(0);
                    var SpecId = reader.GetInt32(1);
                    var TeachId = reader.GetInt32(2);

                    command = connection.CreateCommand();
                    command.CommandText = "ClassroomNumber FROM tbClassroom Where Id =" + ClassroomId + ";";
                    reader = command.ExecuteReader();
                    var ClassroomNumber = reader.GetString(0);
                    //reader.Close();

                    command = connection.CreateCommand();
                    command.CommandText = "PairNumber FROM tbPairTimetable Where Id =" + PairTimetableId + ";";
                    reader = command.ExecuteReader();
                    var PairNumber = reader.GetInt32(0);
                    //reader.Close();

                    command.CommandText = "[Name] FROM tbSubjects WHERE Id = " + SubjId + ";";
                    reader = command.ExecuteReader();
                    var SubjName = reader.GetString(0);
                    //reader.Close();

                    command.CommandText = "FirstName, LastName From tbTeachers Where Id = " + TeachId + ";";
                    reader = command.ExecuteReader();
                    var FirstName = reader.GetString(0);
                    var LastName = reader.GetString(1);
                    //reader.Close();

                    command.CommandText = "[Name] FROM tbSpec WHERE Id = " + SpecId + ";";
                    reader = command.ExecuteReader();
                    var SpecName = reader.GetString(0);
                    //reader.Close();

                    Console.WriteLine($"{ClassroomNumber}\t{PairNumber}\t{SubjName}\t{FirstName}\t{LastName}\t{SpecName} ");

                }
                Console.ReadKey();
                connection.Close();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                Console.ReadLine();
            }
        }
    }
}

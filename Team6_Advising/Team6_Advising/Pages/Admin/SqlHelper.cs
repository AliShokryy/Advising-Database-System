using Microsoft.AspNetCore.Mvc;
using System.Data.SqlClient;
using System.Data;

namespace Team6_Advising.Pages.Admin
{
    public class SqlHelper : Controller
    {
        public static SqlConnection DB_CONNECTION = new SqlConnection( Environment.GetEnvironmentVariable("ConnectionString") ); 

        public static void ExecActionProc(String commandText, params SqlParameter[] parameters)
        {
                using (SqlCommand cmd = new SqlCommand(commandText, DB_CONNECTION))
                {  
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddRange(parameters);

                    cmd.ExecuteNonQuery();
                }
            
        }

        public static bool ExistIn(String? value, String commandText) {
            bool result = false;
            using (SqlCommand command = new SqlCommand(commandText, DB_CONNECTION))
            {
                SqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    if (reader[0].ToString().Equals(value))
                    {
                        result = true;
                        break;
                    }
                }
                reader.Close();
                return result;
            }
   
        }
        public static Int32 ExecuteNonQuery(String connectionString, String commandText,
          CommandType commandType, params SqlParameter[] parameters)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(commandText, conn))
                {
                    // There're three command types: StoredProcedure, Text, TableDirect. The TableDirect   
                    // type is only for OLE DB.    
                    cmd.CommandType = commandType;
                    cmd.Parameters.AddRange(parameters);

                    conn.Open();
                    return cmd.ExecuteNonQuery();
                }
            }
        }

        // Set the connection, command, and then execute the command and only return one value.  
        public static Object ExecuteScalar(String connectionString, String commandText,
            CommandType commandType, params SqlParameter[] parameters)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(commandText, conn))
                {
                    cmd.CommandType = commandType;
                    cmd.Parameters.AddRange(parameters);

                    conn.Open();
                    return cmd.ExecuteScalar();
                }
            }
        }

        // Set the connection, command, and then execute the command with query and return the reader.  
        public static SqlDataReader ExecuteReader(String commandText,
            CommandType commandType, params SqlParameter[] parameters)
        {

            using (SqlCommand cmd = new SqlCommand(commandText, DB_CONNECTION))
            {
                cmd.CommandType = commandType;
                cmd.Parameters.AddRange(parameters);

                // When using CommandBehavior.CloseConnection, the connection will be closed when the   
                // IDataReader is closed.  
                SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.CloseConnection);

                return reader;
            }
        }
    }
}

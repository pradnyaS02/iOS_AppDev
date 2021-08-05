//
//  DBManager.swift
//  SqlPractice
//
//  Created by Pradnya M. S. Suryavanshi on 23/07/21.
//

import Foundation
import SQLite3

class DBManager {
    
    var dbPathURL = try? (FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("school.sqlite").path)
    var tableName="student"
    var db:OpaquePointer?
    
    init() {
        openDatabase()
        createTable()
        
    }
    
    
    func openDatabase(){
        var db:OpaquePointer?
        
//        guard let dbPathURL = dbPathURL else {
//            print("dbPathURL is nil")
//
//        }
        
        if sqlite3_open(self.dbPathURL, &db)==SQLITE_OK{
            print("Successful opening Connection to Database at \(dbPathURL)")
            self.db=db
        }else{
            print("Unable to open Database")
        }
        
        //return db
    }
    
    func createTable(){
        
        let createTableQuery = "CREATE TABLE \(tableName) (id integer primary key autoincrement, name char(50), age int, phoneNo char(10));"
        var createTablePointer: OpaquePointer?
        
        if sqlite3_prepare_v2(db, createTableQuery, -1, &createTablePointer, nil) == SQLITE_OK{
            
            if sqlite3_step(createTablePointer) == SQLITE_DONE{
                print("\nTable Created")
            }
            else{
                print("\nTable is not Created")
            }
        }else{
            print("\nCREATE TABLE statement is not prepared")
        }
        
        sqlite3_finalize(createTablePointer)
    }
    
    
    func insert(nName:String,nAge:Int,nPhoneno:String){
        
        let insertQuery="insert into \(tableName) (id,name,age,phoneNo) values (?,?,?,?);"
        var insertPointer:OpaquePointer?
        
        if sqlite3_prepare(db, insertQuery, -1, &insertPointer, nil) == SQLITE_OK{
            
            let name = nName as NSString
            let age = Int32(nAge)
            let phoneno = nPhoneno as NSString
            
            sqlite3_bind_text(insertPointer, 2, name.utf8String, -1, nil)
            sqlite3_bind_int(insertPointer, 3, age)
            sqlite3_bind_text(insertPointer, 4, phoneno.utf8String, -1, nil)
            
//            Id is autoincrement
            
            if sqlite3_step(insertPointer) == SQLITE_DONE{
                print("\n Successfully inserted row")
            }else{
                print("\n Could not Row inserted")
            }
        }else{
            print("\n INSERT statement is not prepared.")
        }
        
        sqlite3_reset(insertPointer)
        sqlite3_finalize(insertPointer)
    }
    
    
    func update(Uid:Int,Uname:String,Uage:Int,Uphone:String){
        var updateQuery = "update \(tableName) set name=?,age=?,phoneNo=? where id=? "
        var updatePointer : OpaquePointer?
        
        
            if sqlite3_prepare_v2(db, updateQuery, -1, &updatePointer, nil)==SQLITE_OK {
                
                let id = Int32(Uid)
                let name = Uname as NSString
                let age = Int32(Uage)
                let phone = Uphone as NSString
                
                
                sqlite3_bind_int(updatePointer, 4, id)
                sqlite3_bind_text(updatePointer, 1, name.utf8String, -1, nil)
                sqlite3_bind_int(updatePointer, 2, age)
                sqlite3_bind_text(updatePointer, 3, phone.utf8String, -1, nil)
                
                
                if sqlite3_step(updatePointer)==SQLITE_DONE{
                print("\n updated name")
            }else{
                print("\n could not update name")
            }
        }else{
            print("\n Could not prepare updatequery name query")
        }
        sqlite3_finalize(updatePointer)
        
    }
    
    func readStudentValues()->[Student]?{
        
        var arr=[Student]()
        
        let readQuery="SELECT * FROM \(tableName);"
        var readPointer:OpaquePointer?
        
        if sqlite3_prepare_v2(db, readQuery, -1, &readPointer, nil)==SQLITE_OK{
            
            while (sqlite3_step(readPointer)==SQLITE_ROW) {
                
                let id=Int(sqlite3_column_int(readPointer, 0))
                
                guard let col1=sqlite3_column_text(readPointer, 1) else {
                    print("Read query result for col1 is nil")
                    return nil
                }
                let name = String(cString: col1)
                
                let age=sqlite3_column_int(readPointer, 2)
                
                guard let col3=sqlite3_column_text(readPointer, 3) else {
                    print("Read query result for col2 is nil ")
                    return nil
                }
                
                let phoneno=String(cString: col3)
                
                arr.append(Student(Sid: id, Sname: name, Sage: Int(age), SphoneNo: phoneno))
            }
            
        }else{
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        
        sqlite3_finalize(readPointer)
        return arr
    }
    
    func closeDB(){
        sqlite3_close(db)
    }
    
    
}

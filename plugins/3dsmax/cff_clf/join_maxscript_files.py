import toml
import sys


class MaxscriptJoiner:
    def __init__(self, build_filename):
        self.toml_filename = build_filename 
        self.output_filename = ""
        self.files = []
    
    def get_file_data(self, filename):
        try:
            with open("{}\\{}".format(sys.path[0], filename), "r") as ms_file:
                file_data = ""
                comments = ""
                comments_is_on = True
                comments_end = False
                for line in ms_file:                   
                    if not comments_end and line.find('/*') != -1:
                        comments_is_on = True
                        
                    if line.find('filein') == -1 and not comments_is_on:
                        file_data += line 
                    elif comments_is_on:
                        comments += line 
                        
                    if line.find('*/') != -1:
                        comments_is_on = False
                        comments_end = True
        except:
            return None
            
        return file_data
                   
    def join_maxscript_files(self):
        main_ms_file = self.get_file_data(self.filename)               
        
        if main_ms_file == None:
            raise Exception("Can't read file {}.".format(self.filename))
        
        included_ms_files = ""
        for file in self.files:
            included_ms_files += "-- {}\n".format(file)
            included_ms_files += self.get_file_data(file)
            included_ms_files += "\n\n"            
        
        ms_file = included_ms_files + main_ms_file
        
        try:
            with open("{}\\{}\\{}".format(sys.path[0], self.build_folder, self.filename), "w") as file:
                file.writelines(ms_file)
        except:    
            raise Exception("Can't create output file {}.".format(self.filename)) 
        
        return 1

    def parse_toml_file(self, toml_filename):
        try:
            build_file = open(toml_filename, "r").read()
            build_config = toml.loads(build_file)
        except:
            raise Exception('Error parsing file {}'.format(toml_filename))    
    
        for section, params in build_config.items():
            self.filename = params.get("filename")
            self.files = params.get("files")         
            self.build_folder = params.get("folder")
            if not self.build_folder or not self.filename or not self.files:
                raise Exception('Error parsing section {}'.format(toml_filename))
                
    def join_files(self):
        self.parse_toml_file(self.toml_filename)
        self.join_maxscript_files()        
    
    
if __name__ == "__main__":
    if sys.argv:
        msj = MaxscriptJoiner(sys.argv[1])           
        msj.join_files()
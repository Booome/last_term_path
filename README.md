# Last term path

Record Last terminal path to ${XDG_RUNTIME_DIR}/last_term_path.txt
Run this bash as a deamon, and add line into your bashrc as below, 
then you can enter last_term_path while you open a new terminal
```bash
cd $(cat "${XDG_RUNTIME_DIR}/last_term_path.txt")
```


## How to include a new plugin ❓ 

------

Fork this repo on your computer and create a **new branch** with the plugin name.

The plugin [leaflet-arrowheads](https://github.com/slutske22/leaflet-arrowheads) will serve as example for this tutorial.

1. Create a **new directory** in `./inst/htmlwidgets/` with the prefix `lfx-` and the plugin name. This snippet will do that for you:

        usethis::use_directory("/inst/htmlwidgets/lfx-arrowhead")

2. Install the **dependencies** via `npm`/`bower` etc if available. If the package cannot be installed, either fork/download the plugin-repo or copy/paste the JavaScript code manually. This plugin can be installed and requires 2 dependencies. I installed them with:

        npm install leaflet-arrowheads --save
        npm install leaflet-geometryutil --save
This will add the dependencies in the directory `./node_modules/`. Find the directories with the source files and copy those into the new directory `lfx-arrowhead`. In this case the files: **leaflet.geometryutil.js** and **leaflet-arrowheads.js**

3. Create a **new R-file** with the name of the plugin in `./R/`. In this case `arrowhead.R` or copy/paste another R-file and rename it accordingly. Copy/paste the `antpath.R` file and search/replace `antpath` with `arrowhead` and `Antpath` with `Arrowhead`. Adapt the functions and options according to the plugin.

4. Add a **JavaScript-binding** file in the directory `/inst/htmlwidgets/lfx-arrowhead`. Look at other plugins and their bindings for references and examples. In the beginning I use a lot of `console.log()` and `debugger` statements in the JS-methods to get an idea what the data looks like, if all arguments are passed correctly, etc. In this case I also copy/pasted the file `lfx-ant-path-bindings.js`, renamed it `leaflet-arrowheads-bindings.js` and adapted the JavaScript code.           
If the plugin exposes several methods, you can/should write an R-function for every JS-method. The R-function calls the JS-method with `invokeMethod` where the argument *method* should correspond to the JavaScript method you want to invoke. The arrowheads-plugin has the method **deleteArrowheads**. I used that method for two R and JS functions, one where you can remove the arrowheads by **group** (`clearArrowhead`) and one by **layerId** (`removeArrowhead`). In the JS methods `this` always refers to the map-object. If needed, you can also use the `LeafletWidget` object from R-leaflet and the `L` object by leaflet itself.

5. Add an **example** in `./inst/examples/`. I use this directory to demonstrate/test the plugins in **ShinyApps**. Non-interactive examples go straight in the documentation of the function.

6. Add a **test** in `./tests/testthat/` or use this function `usethis::use_test("arrowhead")`

7. **Check** the package and run `devtools::test_coverage()` and try to test all R-code lines. ✅ 
You can also check the coverage of just one file with `devtools::test_coverage_file(paste0(getwd(),"/tests/testthat/test-arrowhead.R"))`. You may have to load some libraries manually before that.

8. Add the new plugin in the **README.md** with a link to the github repo.

8. Add a short description in the **NEWS.md** file that this plugin is now available.

9. If everything works correctly, push it to your fork and **open a PR**. I will be happy to merge it as soon as possible! 💚     
🤷 If you're stuck somewhere in the process and you just can't get it to work, you can still open a PR and explain what the problem is. I will look into it.

10. 🎉 Celebrate and use it 🏆



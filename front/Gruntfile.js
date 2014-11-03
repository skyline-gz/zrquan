module.exports = function(grunt){

    // 项目配置
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        //　SCSS to CSS
        compass: {
            development: {
                options: {
                    require: 'compass/import-once/activate',
                    outputStyle: 'expanded',
                    sassDir: 'src/sass',
                    cssDir: '.development/stylesheets',
                    imagesDir: 'src/images',
                    imagesPath: 'src/images',
                    generatedImagesDir: 'development/images',
                    environment: 'development',
                    specify: 'src/sass/<%= pkg.name %>.scss',
                    banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
                }
            },
            production: {
                options: {
                    config: 'src/config.rb',
                        basePath: 'src',
                        sassDir: 'sass',
                        cssDir: 'css',
                        imagesDir: 'images',
                        environment: 'production',
                        specify: 'src/sass/<%= pkg.name %>.scss',
                        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
                }
            }
        },
        // 合并压缩js文件
        requirejs: {
            development: {
                options: {
                    baseUrl: 'src/scripts',
                    mainConfigFile: 'src/scripts/main.js',
                    name: 'main',
                    out: 'development/javascripts/<%= pkg.name %>.js',
                    optimize: "none",
                    preserveLicenseComments: true
                }
            },
            production: {
                options: {
                    baseUrl: 'src/scripts',
                    mainConfigFile: 'src/scripts/main.js',
                    name: 'main',
                    out: 'build/javascripts/<%= pkg.name %>.min.js',
                    optimize: "uglify",
                    preserveLicenseComments: false
                }
            }
        },
        copy: {
//            scripts4build: {
//                expand: true,
//                cwd: 'src/scripts',
//                src: ['**'],
//                dest: 'src/temp_scripts'
//            },
            imagesSrcToDev: {
                expand: true,
                cwd: 'src/images/',
                src: ['**'],
                dest: 'development/images/'
            },

            //发布到rails的web目录部署
            development: {
                expand: false,
                cwd: 'development/',
                src: ['/**'],
                dest: '../app/assets/'
            }
        },
        // 压缩单个文件
        uglify: {
            development : {
                options: {
                    compress: true
                },
                src: 'src/vendors/requirejs/require.js',
                dest: 'development/javascripts/require.min.js'
            },
            html5shiv : {
                options: {
                    compress: true
                },
                src: 'src/vendors/html5shiv/html5shiv.js',
                dest: 'development/javascripts/html5shiv.min.js'
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-compass');
    grunt.loadNpmTasks('grunt-contrib-requirejs');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-copy');

    // 默认任务(发布到开发环境)
    grunt.registerTask('default', ['compass:development', 'requirejs:development',
        'copy:imagesSrcToDev', 'copy:development']);
};
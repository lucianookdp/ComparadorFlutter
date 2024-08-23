import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[900],
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.blue[900],
          secondary: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.blueGrey[900],
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _alcoolController = TextEditingController();
  final TextEditingController _gasolinaController = TextEditingController();
  String _resultado = "";
  double _precoAlcool = 0;
  double _precoGasolina = 0;
  final _formKey = GlobalKey<FormState>();

  void _calcular() {
    if (_formKey.currentState!.validate()) {
      _precoAlcool = double.parse(_alcoolController.text);
      _precoGasolina = double.parse(_gasolinaController.text);

      double razao = _precoAlcool / _precoGasolina;
      String razaoFormatada = razao.toStringAsFixed(2);

      setState(() {
        if (razao < 0.7) {
          _resultado = "Razão: $razaoFormatada. Abasteça com Álcool!";
        } else {
          _resultado = "Razão: $razaoFormatada. Abasteça com Gasolina!";
        }
      });
    }
  }

  void _limparCampos() {
    _alcoolController.clear();
    _gasolinaController.clear();
    setState(() {
      _resultado = "";
      _precoAlcool = 0;
      _precoGasolina = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Álcool ou Gasolina?'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.local_gas_station,
                size: 80.0, // Diminuindo o tamanho da logo
                color: Colors.white,
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _alcoolController,
                label: "Preço do Álcool (R\$)",
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _gasolinaController,
                label: "Preço da Gasolina (R\$)",
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _calcular,
                      child: Text("Calcular"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        padding: EdgeInsets.symmetric(vertical: 15),
                        textStyle: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _limparCampos,
                      child: Text("Limpar"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        textStyle: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                _resultado,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.blue[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              if (_precoAlcool > 0 && _precoGasolina > 0)
                Column(
                  children: [
                    Container(
                      height: 200, // Aumentando a altura do gráfico para melhor visibilidade
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          barGroups: [
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(
                                  y: _precoAlcool,
                                  colors: [Colors.blue[700]!],
                                  width: 30, // Aumentando a largura das barras
                                  borderRadius: BorderRadius.circular(0),
                                ),
                              ],
                              barsSpace: 20,
                            ),
                            BarChartGroupData(
                              x: 1,
                              barRods: [
                                BarChartRodData(
                                  y: _precoGasolina,
                                  colors: [Colors.purple[700]!], // Usando roxo para a segunda barra
                                  width: 30, // Aumentando a largura das barras
                                  borderRadius: BorderRadius.circular(0),
                                ),
                              ],
                              barsSpace: 20,
                            ),
                          ],
                          titlesData: FlTitlesData(
                            bottomTitles: SideTitles(
                              showTitles: true,
                              getTitles: (double value) {
                                switch (value.toInt()) {
                                  case 0:
                                    return 'Álcool';
                                  case 1:
                                    return 'Gasolina';
                                  default:
                                    return '';
                                }
                              },
                              margin: 10, // Margem para o texto ficar um pouco mais afastado das barras
                            ),
                            leftTitles: SideTitles(showTitles: false),
                          ),
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              tooltipBgColor: Colors.grey,
                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                String fuelType;
                                switch (group.x.toInt()) {
                                  case 0:
                                    fuelType = 'Álcool';
                                    break;
                                  case 1:
                                    fuelType = 'Gasolina';
                                    break;
                                  default:
                                    throw Error();
                                }
                                return BarTooltipItem(
                                  '$fuelType\n',
                                  TextStyle(
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: rod.y.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label}) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white, fontSize: 18.0),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.blueGrey[800],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira um valor';
        }
        if (double.tryParse(value) == null) {
          return 'Insira um número válido';
        }
        return null;
      },
    );
  }
}

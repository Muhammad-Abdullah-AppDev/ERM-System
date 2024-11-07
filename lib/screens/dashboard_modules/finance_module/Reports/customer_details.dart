import 'package:flutter/material.dart';

class CustomerDetailsScreen  extends StatefulWidget {

  const CustomerDetailsScreen ({this.selectedCustomerId, this.selectedCustomerBal, super.key, this.selectedCustomerName});
  final String? selectedCustomerId;
  final String? selectedCustomerName;
  final double? selectedCustomerBal;

  @override
  State<CustomerDetailsScreen > createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen > {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint('Customer Name: ${widget.selectedCustomerName}');
    debugPrint('Pkcode: ${widget.selectedCustomerId}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF144b9d),
        foregroundColor: Colors.white,
        title: Text('Customer Details'),
      ),
      body: Card(
    child: ListTile(
    tileColor: Colors.blue[50],
      title: Text('${widget.selectedCustomerName}',
          style: TextStyle(
              fontSize: 14, color: Colors.black)),
      trailing: Text('${widget.selectedCustomerBal}',
          style: TextStyle(
              fontSize: 14, color: Colors.black)),
    ),
    ),
    );
  }
}

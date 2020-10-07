// Copyright 2020 The Stellar Flutter SDK Authors. All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE file.

import 'muxed_account.dart';
import 'xdr/xdr_ledger.dart';
import 'operation.dart';
import 'util.dart';
import 'xdr/xdr_operation.dart';
import 'xdr/xdr_account.dart';
import "dart:typed_data";

class ClaimClaimableBalanceOperation extends Operation {
  String _balanceId;

  ClaimClaimableBalanceOperation(String balanceId) {
    this._balanceId = checkNotNull(balanceId, "balanceId cannot be null");
  }

  String get balanceId => _balanceId;

  @override
  XdrOperationBody toOperationBody() {
    XdrClaimClaimableBalanceOp op = XdrClaimClaimableBalanceOp();

    XdrClaimableBalanceID bId = XdrClaimableBalanceID();
    bId.discriminant = XdrClaimableBalanceIDType.CLAIMABLE_BALANCE_ID_TYPE_V0;
    List<int> list = balanceId.codeUnits;
    Uint8List bytes = Uint8List.fromList(list);
    bId.v0.hash = bytes;
    op.balanceID = bId;

    XdrOperationBody body = XdrOperationBody();
    body.discriminant = XdrOperationType.CLAIM_CLAIMABLE_BALANCE;
    body.claimClaimableBalanceOp = op;
    return body;
  }

  static ClaimClaimableBalanceOperation builder(
      XdrClaimClaimableBalanceOp op) {
    String balanceId = String.fromCharCodes(op.balanceID.v0.hash);
    return ClaimClaimableBalanceOperation(balanceId);
  }
}

class ClaimClaimableBalanceOperationBuilder {

  String _balanceId;
  MuxedAccount _mSourceAccount;

  ClaimClaimableBalanceOperationBuilder(this._balanceId);

  /// Sets the source account for this operation represented by [sourceAccount].
  ClaimClaimableBalanceOperationBuilder setSourceAccount(
      String sourceAccount) {
    checkNotNull(sourceAccount, "sourceAccount cannot be null");
    _mSourceAccount = MuxedAccount(sourceAccount, null);
    return this;
  }

  /// Sets the muxed source account for this operation represented by [sourceAccountId].
  ClaimClaimableBalanceOperationBuilder setMuxedSourceAccount(
      MuxedAccount sourceAccount) {
    _mSourceAccount =
        checkNotNull(sourceAccount, "sourceAccount cannot be null");
    return this;
  }

  ///Builds an operation
  ClaimClaimableBalanceOperation build() {
    ClaimClaimableBalanceOperation operation =
    ClaimClaimableBalanceOperation(_balanceId);
    if (_mSourceAccount != null) {
      operation.sourceAccount = _mSourceAccount;
    }
    return operation;
  }
}
